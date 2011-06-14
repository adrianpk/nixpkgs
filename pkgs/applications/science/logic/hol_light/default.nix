{stdenv, fetchsvn, writeScript, ocaml, findlib, camlp5}:

stdenv.mkDerivation rec {
  name = "hol_light-20110611";
  src = fetchsvn {
    url = http://hol-light.googlecode.com/svn/trunk;
    rev = "92";
    sha256 = "773fd353c06ebcbba28d2ba8cc495bd3ab0bb6f3f722f566fb3261a27a873ca0";
  };

  buildInputs = [ ocaml findlib camlp5 ];

  start_script = ''
    #!/bin/sh
    cd "$out/lib/hol_light"
    exec ${ocaml}/bin/ocaml -I "$(ocamlfind query camlp5)" -init make.ml
  '';

  buildPhase = ''
    make pa_j.ml
    ocamlc -c \
      -pp "camlp5r pa_lexer.cmo pa_extend.cmo q_MLast.cmo" \
      -I "$(ocamlfind query camlp5)" \
      pa_j.ml
  '';

  installPhase = ''
    ensureDir "$out/lib/hol_light" "$out/bin"
    cp -a  . $out/lib/hol_light
    echo "${start_script}" > "$out/bin/hol_light"
    chmod a+x "$out/bin/hol_light"
  '';

  meta = {
    description = "An interactive theorem prover based on Higher-Order Logic.";
    longDescription = ''
HOL Light is a computer program to help users prove interesting mathematical
theorems completely formally in Higher-Order Logic.  It sets a very exacting
standard of correctness, but provides a number of automated tools and
pre-proved mathematical theorems (e.g., about arithmetic, basic set theory and
real analysis) to save the user work.  It is also fully programmable, so users
can extend it with new theorems and inference rules without compromising its
soundness.
    '';
    homepage = http://www.cl.cam.ac.uk/~jrh13/hol-light/;
    license = "BSD";
  };
}
