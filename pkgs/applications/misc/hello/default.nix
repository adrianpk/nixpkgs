{stdenv, fetchurl, perl}:

derivation {
  name = "hello-2.1.1";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/hello/hello-2.1.1.tar.gz;
    md5 = "70c9ccf9fac07f762c24f2df2290784d";
  };
  stdenv = stdenv;
  perl = perl;
}
