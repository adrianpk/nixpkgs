{stdenv, fetchurl, m4, perl, libtool}:
derivation {
  name = "autoconf-2.58-with-libtool";
  system = stdenv.system;
  builder = ./libtoolbuilder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/autoconf/autoconf-2.58.tar.bz2;
    md5 = "db3fa3069c6554b3505799c7e1022e2b";
  };
  stdenv = stdenv;
  m4 = m4;
  perl = perl;
  libtool = libtool;
}
