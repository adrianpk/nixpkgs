{stdenv, fetchurl, perl}:

stdenv.mkDerivation {
  name = "hello-2.1.1";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/hello-2.1.1.tar.gz;
    md5 = "70c9ccf9fac07f762c24f2df2290784d";
  };
  buildInputs = [perl];
}
