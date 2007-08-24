{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "fribidi-0.10.7";
  src = fetchurl {
    url = http://fribidi.org/download/fribidi-0.10.7.tar.gz;
    md5 = "0f602ed32869dbc551dc6bc83d8a3d28";
  };
}
