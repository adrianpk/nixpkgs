{ perlSupport, pythonSupport, javaSupport
, stdenv, fetchurl, perl ? null, python ? null, jdk ? null}:

assert perlSupport -> perl != null;
assert pythonSupport -> python != null;
assert javaSupport -> jdk != null;

stdenv.mkDerivation {
  name = "swig-1.3.19";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/swig-1.3.19.tar.gz;
    md5 = "a733455544426b31868dd87fc162e750";
  };

  inherit perlSupport pythonSupport javaSupport;

  perl = if perlSupport then perl else null;
  python = if pythonSupport then python else null;
  jdk = if javaSupport then jdk else null;
}