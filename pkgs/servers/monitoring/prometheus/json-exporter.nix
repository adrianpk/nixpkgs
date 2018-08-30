# This file was generated by go2nix.
{ buildGoPackage, fetchFromGitHub, lib }:

buildGoPackage rec {
  name = "prometheus-json-exporter-${version}";
  version = "unstable-2016-09-13";
  rev = "d45e5ebdb08cb734ad7a8683966032af1d91a76c";

  goPackagePath = "github.com/kawamuray/prometheus-json-exporter";

  src = fetchFromGitHub {
    inherit rev;
    owner = "kawamuray";
    repo = "prometheus-json-exporter";
    sha256 = "0v3as7gakdqpsir97byknsrqxxxkq66hp23j4cscs45hsdb24pi9";
  };

  goDeps = ./json-exporter_deps.nix;

  meta = {
    description = "A prometheus exporter which scrapes remote JSON by JSONPath";
    homepage = https://github.com/kawamuray/prometheus-json-exporter;
    license = lib.licenses.asl20;
  };
}
