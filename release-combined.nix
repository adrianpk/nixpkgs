{
  nixos = import ./release.nix;
  nixpkgs = import <nixpkgs/pkgs/top-level/release.nix>;
}
