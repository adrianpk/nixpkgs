{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "ncurses-5.5";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/ncurses-5.5.tar.gz;
    md5 = "e73c1ac10b4bfc46db43b2ddfd6244ef";
  };
}
