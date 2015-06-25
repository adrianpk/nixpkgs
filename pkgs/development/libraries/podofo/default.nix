{ stdenv, fetchurl, cmake, zlib, freetype, libjpeg, libtiff, fontconfig
, openssl, libpng, lua5 }:

stdenv.mkDerivation rec {
  name = "podofo-0.9.3";

  src = fetchurl {
    url = "mirror://sourceforge/podofo/${name}.tar.gz";
    sha256 = "1n12lbq9x15vqn7dc0hsccp56l5jdff1xrhvlfqlbklxx0qiw9pc";
  };

  propagatedBuildInputs = [ zlib freetype libjpeg libtiff fontconfig openssl libpng ];
  nativeBuildInputs = [ cmake ];
  buildInputs = [ lua5 stdenv.gcc.libc ];

  crossAttrs = {
    propagatedBuildInputs = [ zlib.crossDrv freetype.crossDrv libjpeg.crossDrv
      libtiff.crossDrv fontconfig.crossDrv openssl.crossDrv libpng.crossDrv
      lua5.crossDrv stdenv.gccCross.libc ];
  };

  # fix finding freetype-2.5
  preConfigure = ''
    substituteInPlace ./CMakeLists.txt \
      --replace FREETYPE_INCLUDE_DIR FREETYPE_INCLUDE_DIRS \
      --replace 'FIND_PACKAGE(FREETYPE' 'FIND_PACKAGE(Freetype'

    rm ./cmake/modules/Find{FREETYPE,ZLIB,PkgConfig}.cmake
  '';

  cmakeFlags = "-DPODOFO_BUILD_SHARED=ON -DPODOFO_BUILD_STATIC=OFF";

  meta = {
    homepage = http://podofo.sourceforge.net;
    description = "A library to work with the PDF file format";
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
