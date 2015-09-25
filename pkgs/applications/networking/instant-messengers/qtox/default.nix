{ stdenv, fetchgit, pkgconfig, libtoxcore-dev, qt5, openal, opencv,
  libsodium, libXScrnSaver, glib, gdk_pixbuf, gtk2, cairo,
  pango, atk, qrencode, ffmpeg, filter-audio, makeWrapper }:

let
  revision = "2f6b5e052f2a625d506e83f880c5d68b49118f95";
in

stdenv.mkDerivation rec {
  name = "qtox-dev-20150821";

  src = fetchgit {
      url = "https://github.com/tux3/qTox.git";
      rev = "${revision}";
      md5 = "b2f9cf283136b6e558876ca2e6d128a3";
  };

  buildInputs =
    [
      libtoxcore-dev openal opencv libsodium filter-audio
      qt5.base qt5.tools libXScrnSaver glib gtk2 cairo
      pango atk qrencode ffmpeg qt5.translations makeWrapper
    ];

  nativeBuildInputs = [ pkgconfig ];

  preConfigure = ''
    # patch .pro file for proper set of the git hash
    sed -i '/git rev-parse/d' qtox.pro
    sed -i 's/$$quote($$GIT_VERSION)/${revision}/' qtox.pro
    # since .pro have hardcoded paths, we need to explicitly set paths here
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE $(pkg-config --cflags glib-2.0)"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE $(pkg-config --cflags gdk-pixbuf-2.0)"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE $(pkg-config --cflags gtk+-2.0)"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE $(pkg-config --cflags cairo)"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE $(pkg-config --cflags pango)"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE $(pkg-config --cflags atk)"
  '';

  configurePhase = ''
    runHook preConfigure
    qmake
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp qtox $out/bin
    wrapProgram $out/bin/qtox \
      --prefix QT_PLUGIN_PATH : ${qt5.svg}/lib/qt5/plugins
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Qt Tox client";
    license = licenses.gpl3;
    maintainers = with maintainers; [ viric jgeerds akaWolf ];
    platforms = platforms.all;
  };
}
