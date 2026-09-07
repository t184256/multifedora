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
    in
    {
      devShells.x86_64-linux.default = pkgs.mkShell {
        packages = with pkgs; [
          coreutils gnumake gnused diffutils
          qemu_kvm OVMF libguestfs-with-appliance netcat wget parted
          cryptsetup btrfs-progs util-linux openssh
          dosfstools mtools xorriso
          unprivMkefiboot mkksiso
        ];
        shellHook = ''export OVMF="${pkgs.OVMF.fd}/FV"'';
      };
    };
}
