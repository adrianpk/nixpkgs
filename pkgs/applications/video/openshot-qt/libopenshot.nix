{ stdenv, fetchFromGitHub
, pkgconfig, cmake, doxygen
, libopenshot-audio, imagemagick, ffmpeg
, swig, python3
, unittest-cpp, cppzmq, czmqpp
, qtbase, qtmultimedia }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "libopenshot-${version}";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "OpenShot";
    repo = "libopenshot";
    rev = "v${version}";
    sha256 = "1x4kv05pdq1pglb6y056aa7llc6iyibyhzg93k7zwj0q08cp5ixd";
  };

  patchPhase = ''
    sed -i 's/{UNITTEST++_INCLUDE_DIR}/ENV{UNITTEST++_INCLUDE_DIR}/g' tests/CMakeLists.txt
    sed -i 's/{_REL_PYTHON_MODULE_PATH}/ENV{_REL_PYTHON_MODULE_PATH}/g' src/bindings/python/CMakeLists.txt
    export _REL_PYTHON_MODULE_PATH=$(toPythonPath $out)
  '';

  nativeBuildInputs = [ pkgconfig cmake doxygen ];

  buildInputs =
  [ imagemagick ffmpeg swig python3 unittest-cpp
    cppzmq czmqpp qtbase qtmultimedia ];

  LIBOPENSHOT_AUDIO_DIR = "${libopenshot-audio}";
  "UNITTEST++_INCLUDE_DIR" = "${unittest-cpp}/include/UnitTest++";

  doCheck = false;

  cmakeFlags = [ "-DENABLE_RUBY=OFF" ];

  meta = {
    homepage = http://openshot.org/;
    description = "Free, open-source video editor library";
    longDescription = ''
      OpenShot Library (libopenshot) is an open-source project dedicated to
      delivering high quality video editing, animation, and playback solutions
      to the world. API currently supports C++, Python, and Ruby.
    '';
    license = with licenses; gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; linux;
  };
}
