{ stdenv, fetchFromGitHub, gdal, cmake, ninja, proj, clipper, zlib, qtbase, qttools
  , qtlocation, qtsensors, doxygen, cups, makeWrapper, qtimageformats
}:

stdenv.mkDerivation rec {
  name = "OpenOrienteering-Mapper-${version}";
  version = "0.8.1.2";

  buildInputs = [ gdal qtbase qttools qtlocation qtimageformats
                  qtsensors clipper zlib proj doxygen cups];

  nativeBuildInputs = [ cmake makeWrapper ninja ];

  src = fetchFromGitHub {
    owner = "OpenOrienteering";
    repo = "mapper";
    rev = "v${version}";
    sha256 = "0f7zxzl2n46qy86k6n3f6a7l1nhba58i28l8ngp3drf74qffaa33";
  };

  cmakeFlags =
    [
    # Required by the build to be specified
    "-DPROJ4_ROOT=${proj}"

    # Building the manual and bundling licenses fails
    "-DLICENSING_PROVIDER:BOOL=OFF"
    "-DMapper_MANUAL_QTHELP:BOOL=OFF"
    ] ++
    (stdenv.lib.optionals stdenv.isDarwin
    [
    # Usually enabled on Darwin
    "-DCMAKE_FIND_FRAMEWORK=never"
    # FindGDAL is broken and always finds /Library/Framework unless this is
    # specified
    "-DGDAL_INCLUDE_DIR=${gdal}/include"
    "-DGDAL_CONFIG=${gdal}/bin/gdal-config"
    "-DGDAL_LIBRARY=${gdal}/lib/libgdal.dylib"
    # Don't bundle libraries
    "-DMapper_PACKAGE_PROJ=0"
    "-DMapper_PACKAGE_QT=0"
    "-DMapper_PACKAGE_ASSISTANT=0"
    "-DMapper_PACKAGE_GDAL=0"
    ]);


  postInstall =
    stdenv.lib.optionalString stdenv.isDarwin ''
    # Fixes "This application failed to start because it could not find or load the Qt
    # platform plugin "cocoa"."
    wrapProgram $out/Mapper.app/Contents/MacOS/Mapper \
      --set QT_QPA_PLATFORM_PLUGIN_PATH ${qtbase.bin}/lib/qt-*/plugins/platforms \
      --set QT_PLUGIN_PATH ${qtbase.bin}/${qtbase.qtPluginPrefix}:${qtimageformats}/${qtbase.qtPluginPrefix}
    mkdir -p $out/bin
    ln -s $out/Mapper.app/Contents/MacOS/Mapper $out/bin/mapper
    '';

  meta = {
    description = ''
      OpenOrienteering Mapper is an orienteering mapmaking program
      and provides a free alternative to the existing proprietary solution.
    '';
    homepage = https://www.openorienteering.org/apps/mapper/;
    license = stdenv.lib.licenses.gpl3;
    platforms = with stdenv.lib.platforms; darwin;
    maintainers = with stdenv.lib.maintainers; [mpickering];
  };
}
