{stdenv, fetchurl, ocaml, findlib }:

stdenv.mkDerivation {
  name = "ocaml-twt-0.93.2";

  src = fetchurl {
    url = https://github.com/mlin/twt/archive/v0.93.2.tar.gz;
    sha256 = "aec091fbd1e6c4d252cf9664237418b4bc8c7d6b7a17475589be78365397e768";
  };

  buildInputs = [ ocaml findlib ];

  createFindlibDestdir = true;

  configurePhase = ''
    mkdir $out/bin
  '';

  installPhase = ''
    make install PREFIX=$out
  '';

  meta = {
    homepage = http://people.csail.mit.edu/mikelin/ocaml+twt/;
    description = "“The Whitespace Thing” for OCaml";
    license = stdenv.lib.licenses.mit;
    platforms = ocaml.meta.platforms;
  };
}
