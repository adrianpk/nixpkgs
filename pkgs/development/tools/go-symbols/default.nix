{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "go-symbols-${version}";
  version = "0.1.1";

  goPackagePath = "github.com/acroca/go-symbols";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "acroca";
    repo = "go-symbols";
    rev = "v${version}";
    sha256 = "0yyzw6clndb2r5j9isyd727njs98zzp057v314vfvknsm8g7hqrz";
  };

  meta = {
    description = "A utility for extracting a JSON representation of the package symbols from a go source tree.";
    homepage = https://github.com/acroca/go-symbols;
    maintainers = with stdenv.lib.maintainers; [ vdemeester ];
    license = stdenv.lib.licenses.mit;
  };
}
