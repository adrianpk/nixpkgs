# This file was generated by go2nix.
{ stdenv, lib, fetchgit }:

let
  goDeps = [
    {
      root = "github.com/eckardt/influxdb-backup";
      src = fetchgit {
        url = https://github.com/eckardt/influxdb-backup.git;
        rev = "4556edbffa914a8c17fa1fa1564962a33c6c7596";
        sha256 = "2928063e6dfe4be7b69c8e72e4d6a5fc557f0c75e9625fadf607d59b8e80e34b";
      };
    }
    {
      root = "github.com/eckardt/influxdb-go";
      src = fetchgit {
        url = https://github.com/eckardt/influxdb-go.git;
        rev = "8b71952efc257237e077c5d0672e936713bad38f";
        sha256 = "5318c7e1131ba2330c90a1b67855209e41d3c77811b1d212a96525b42d391f6e";
      };
    }
  ];

in

stdenv.mkDerivation rec {
  name = "go-deps";

  buildCommand =
    lib.concatStrings
      (map (dep: ''
              mkdir -p $out/src/`dirname ${dep.root}`
              ln -s ${dep.src} $out/src/${dep.root}
            '') goDeps);
}
