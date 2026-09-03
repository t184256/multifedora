{
  description = "multifedora";

  outputs = { self, nixpkgs }: {
    devShells.x86_64-linux.default =
      let pkgs = nixpkgs.legacyPackages.x86_64-linux; in pkgs.mkShell {
        packages = with pkgs; [
          coreutils gnumake
          qemu_kvm OVMF libguestfs-with-appliance netcat wget parted
          cryptsetup btrfs-progs util-linux openssh
        ];
        shellHook = ''export OVMF="${pkgs.OVMF.fd}/FV"'';
      };
  };
}
