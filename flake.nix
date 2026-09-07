{
  description = "multifedora";

  outputs = { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;

      unprivMkefiboot = pkgs.runCommand "tool-unprivileged-mkefiboot" {} ''
        mkdir -p $out/bin
        install -m755 ${./test/tool-unprivileged-mkefiboot} $out/bin/mkefiboot
      '';

      mkksiso = pkgs.stdenvNoCC.mkDerivation {
        pname = "mkksiso";
        version = "ba5acecfb45";
        src = pkgs.fetchFromGitHub {
          owner = "weldr";
          repo = "lorax";
          rev = "ba5acecfb45cf860c39fc0c64fdf4630c78accd2";
          hash = "sha256-nwRb7OWLw7S+AfmjttwiWIZjqy59Qj5J4BpDYIlm5Ks=";
        };
        dontConfigure = true;
        dontBuild = true;
        installPhase = ''
          mkdir -p $out/bin
          install -m755 src/bin/mkksiso $out/bin/
          substituteInPlace $out/bin/mkksiso \
            --replace-fail "#!/usr/bin/python3" \
                           "#!${pkgs.python3}/bin/python3" \
            --replace-fail "os.getuid() != 0" "False" \
            --replace-fail 'env={"LANG": "C"}' \
                           'env={**os.environ, "LANG": "C"}' \
            --replace-fail '"mkefiboot"' "\"${unprivMkefiboot}/bin/mkefiboot\""
        '';
      };

      multifedoraScripts = pkgs.runCommand "multifedora-rpm-src" {} ''
        mkdir -p $out
        # store paths carry hash-prefixed names, so name the targets
        cp ${./multifedora} $out/multifedora
        cp ${./multifedora-extract} $out/multifedora-extract
        cp ${./multifedora-inject} $out/multifedora-inject
        cp ${./multifedora-esp-menu} $out/multifedora-esp-menu
        cp ${./multifedora-new-secondary} $out/multifedora-new-secondary
        cp ${./multifedora-remove} $out/multifedora-remove
        cp ${./multifedora-reseat} $out/multifedora-reseat
      '';

      multifedoraRpm = pkgs.runCommand "multifedora-0.1" {
        nativeBuildInputs = [ pkgs.rpm ];
      } ''
        TOPDIR=$(mktemp -d)
        mkdir -p $TOPDIR/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS,tmp,db}
        cp ${./multifedora.spec} $TOPDIR/SPECS/multifedora.spec
        rpmbuild --nodeps \
          --define "srcdir ${multifedoraScripts}" \
          --define "_prefix /usr" --define "_topdir $TOPDIR" \
          --define "_tmppath $TOPDIR/tmp" --define "_dbpath $TOPDIR/db" \
          -bb $TOPDIR/SPECS/multifedora.spec
        mkdir -p $out
        cp $TOPDIR/RPMS/noarch/*.rpm $out/
      '';
    in
    {
      packages.x86_64-linux.multifedora-rpm = multifedoraRpm;
      devShells.x86_64-linux.default = pkgs.mkShell {
        packages = with pkgs; [
          coreutils gnumake gnused diffutils
          qemu_kvm OVMF netcat wget parted
          cryptsetup btrfs-progs util-linux openssh
          dosfstools mtools xorriso
          unprivMkefiboot mkksiso
        ];
        shellHook = ''
          export OVMF="${pkgs.OVMF.fd}/FV"
        '';
      };
    };
}
