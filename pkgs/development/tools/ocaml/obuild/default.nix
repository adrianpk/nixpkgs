{ stdenv, fetchzip, ocamlPackages }:

let version = "0.1.8"; in

stdenv.mkDerivation {
  name = "obuild-${version}";

  src = fetchzip {
    url = "https://github.com/ocaml-obuild/obuild/archive/obuild-v${version}.tar.gz";
    sha256 = "1q1k2qqd08j1zakvydgvwgwpyn0ll7rs65gap0pvg3amnh5cp3wd";
  };

  buildInputs = with ocamlPackages; [ ocaml findlib ];

  buildPhase = ''
    ./bootstrap
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp dist/build/obuild/obuild dist/build/obuild-from-oasis/obuild-from-oasis dist/build/obuild-simple/obuild-simple $out/bin/
  '';

  meta = {
    homepage = https://github.com/ocaml-obuild/obuild;
    platforms = ocamlPackages.ocaml.meta.platforms or [];
    description = "Simple package build system for OCaml";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = with stdenv.lib.maintainers; [ volth ];
  };
}
