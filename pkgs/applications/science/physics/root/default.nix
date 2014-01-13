{ stdenv, fetchurl, cmake, mesa, libX11, gfortran, libXpm, libXft, libXext, zlib }:

stdenv.mkDerivation rec {
  name = "root_v5.34.14";

  src = fetchurl {
    url = "ftp://root.cern.ch/root/${name}.source.tar.gz";
    sha256 = "d5347ba1b614eb083cf08050b784d66a93c125ed89938708da1adb33323dee2b";
  };

  buildInputs = [ cmake gfortran mesa libX11 libXpm libXft libXext zlib ];

  # CMAKE_INSTALL_RPATH_USE_LINK_PATH is set to FALSE in
  # <rootsrc>/cmake/modules/RootBuildOptions.cmake.
  # This patch sets it to TRUE.
  patches = [ ./cmake.patch ];
  patchFlags = "-p0";

  meta = {
    description = "A data analysis framework";
    #maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.mesaPlatforms;
  };
}
