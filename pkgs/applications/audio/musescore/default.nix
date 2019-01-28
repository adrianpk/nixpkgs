{ stdenv, lib, fetchFromGitHub, cmake, pkgconfig
, alsaLib, freetype, libjack2, lame, libogg, libpulseaudio, libsndfile, libvorbis
, portaudio, portmidi, qtbase, qtdeclarative, qtscript, qtsvg, qttools
, qtwebengine, qtxmlpatterns
}:

stdenv.mkDerivation rec {
  name = "musescore-${version}";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner  = "musescore";
    repo   = "MuseScore";
    rev    = "v${version}";
    sha256 = "085qwfv3fsgry1pnx531w83lnyvf7kbaklipdf8zqa9shi6d3x9i";
  };

  patches = [
    ./remove_qtwebengine_install_hack.patch
  ];

  cmakeFlags = [
  ] ++ lib.optional (lib.versionAtLeast freetype.version "2.5.2") "-DUSE_SYSTEM_FREETYPE=ON";

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    alsaLib libjack2 freetype lame libogg libpulseaudio libsndfile libvorbis
    portaudio portmidi # tesseract
    qtbase qtdeclarative qtscript qtsvg qttools qtwebengine qtxmlpatterns
  ];

  meta = with stdenv.lib; {
    description = "Music notation and composition software";
    homepage = https://musescore.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ vandenoever ];
    platforms = platforms.linux;
    repositories.git = https://github.com/musescore/MuseScore;
  };
}
