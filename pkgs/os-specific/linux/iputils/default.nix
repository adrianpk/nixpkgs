{stdenv, fetchurl, kernelHeaders, glibc}:

stdenv.mkDerivation {
  name = "iputils";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.tux.org/pub/net/ip-routing/iputils-ss021109-try.tar.bz2;
    md5 = "dd10ef3d76480990a2174d2bb0daddaf";
  };

  inherit kernelHeaders glibc;
}
