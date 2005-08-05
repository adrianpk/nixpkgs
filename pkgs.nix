rec {
  inherit (import /nixpkgs/trunk/pkgs/system/i686-linux.nix)
    stdenv kernel bash coreutils findutils utillinux sysvinit e2fsprogs
    nettools nix subversion gcc wget which vim less screen openssh binutils
    strace shadowutils iputils gnumake curl gnused gnutar gnugrep gzip
    mingetty grub syslinux parted;

  boot = (import ./boot) {inherit stdenv kernel bash coreutils findutils
    utillinux sysvinit e2fsprogs nettools nix subversion gcc wget which vim
    less screen openssh binutils strace shadowutils iputils gnumake curl
    gnused gnutar gnugrep gzip mingetty grub parted;};

  init = (import ./init) {inherit stdenv bash coreutils 
    utillinux e2fsprogs nix shadowutils mingetty grub parted;};

  everything = [boot init sysvinit kernel];
}
