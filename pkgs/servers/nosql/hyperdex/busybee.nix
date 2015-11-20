{ stdenv, fetchurl, unzip, autoconf, automake, libtool,
  libpo6, libe, pkgconfig }:

stdenv.mkDerivation rec {
  name = "busybee-${version}";
  version = "0.5.2";

  src = fetchurl {
    url = "https://github.com/rescrv/busybee/archive/releases/${version}.zip";
    sha256 = "0b51h1kmkf0s3d9y7wjqgp1pk1rk9i7n8bcgyj01kflzdgafbl0b";
  };
  buildInputs = [
    autoconf
    automake
    libe
    libpo6
    libtool
    pkgconfig
    unzip
  ];
  preConfigure = "autoreconf -i";

  meta = with stdenv.lib; {
    description = "A high-performance messaging layer";
    homepage = https://github.com/rescrv/busybee;
    license = licenses.bsd3;
  };
}
