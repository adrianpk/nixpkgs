{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "cua-mode-2.10";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.cua.dk/cua.el;
    md5 = "5bf5e43f5f38c8383868c7c6c5baca09";
  };
}
