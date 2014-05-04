{ stdenv, R, packages, makeWrapper }:

stdenv.mkDerivation {
  name = R.name + "-wrapper";

  buildInputs = [makeWrapper R] ++ packages;

  unpackPhase = ":";

  installPhase = ''
    mkdir -p $out/bin
    cd ${R}/bin
    for exe in *; do
      makeWrapper ${R}/bin/$exe $out/bin/$exe \
        --prefix "R_LIBS_SITE" ":" "$R_LIBS_SITE"
    done
  '';
}
