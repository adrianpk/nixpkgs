{ stdenv, fetchurl, openssl, db4, expat, perl, zlib
, sslSupport, db4Support
}:

assert sslSupport -> openssl != null;
assert db4Support -> db4 != null;
assert expat != null && perl != null;

stdenv.mkDerivation {
  name = "apache-httpd-2.2.6";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://archive.apache.org/dist/httpd/httpd-2.2.6.tar.bz2;
    md5 = "203bea91715064f0c787f6499d33a377";
  };

  inherit sslSupport db4Support;

  inherit perl expat zlib;
  openssl = if sslSupport then openssl else null;
  db4 = if db4Support then db4 else null;

  meta = {
    description = "Apache HTTPD, the world's most popular web server";
  };
}
