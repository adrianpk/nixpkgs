# This file was generated by go2nix.
{ stdenv, lib, goPackages, fetchgit, fetchhg, fetchbzr, fetchsvn }:

with goPackages;

buildGoPackage rec {
  name = "asciinema-${version}";
  version = "20160520-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "6683bdaa263d0ce3645b87fe54aa87276b89988a";

  
  goPackagePath = "github.com/asciinema/asciinema";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/asciinema/asciinema";
    sha256 = "08jyvnjpd5jdgyvkly9fswac4p10bqim5v4rhmivpg4y8pbcmxkz";
  };
}
