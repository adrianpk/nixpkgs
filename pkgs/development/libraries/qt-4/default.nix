args: with args;

stdenv.mkDerivation {
  name = "qt-4.5.1";
  
  src = fetchurl {
    url = ftp://ftp.trolltech.com/qt/source/qt-x11-opensource-src-4.5.1.tar.bz2;
    sha256 = "b994c40e41386c9d82f025dd9198e1161717021216680adef97da3f1b8947c75";
  };
  
  setupHook = ./setup-hook.sh;
  
  propagatedBuildInputs = [
    libXft 
    libXrender 
    libXrandr 
    randrproto 
    xextproto
    libXinerama 
    xineramaproto 
    libXcursor 
    zlib 
    libjpeg 
    mysql 
    libpng 
    which 
    mesa
    libXmu 
    openssl 
    dbus.libs 
    cups 
    pkgconfig 
    libXext 
    freetype 
    fontconfig 
    inputproto
    fixesproto 
    libXfixes 
    glib 
    libtiff
  ];
  
  prefixKey = "-prefix ";
  
  configureFlags = ''
    -v -no-separate-debug-info -release
    -system-zlib -system-libpng -system-libjpeg -fast
    -qt-gif -confirm-license
    -opengl -xrender -xrandr -xinerama -xcursor -qt-sql-mysql
    -qdbus -cups -glib -xfixes -dbus-linked
    -fontconfig -I${freetype}/include/freetype2
  '';

  patchPhase = ''
    substituteInPlace configure --replace /bin/pwd pwd
    sed -e 's@/usr@/FOO@' -i config.tests/*/*.test -i mkspecs/*/*.conf
  '';

  # Remove the documentation: it takes up >= 130 MB, which is more
  # than half of the installed size.  Ideally we should put this in a
  # separate package (as well as the Qt Designer).
  postInstall = ''
    rm -rf $out/doc
  '';

  meta = {
    homepage = http://www.qtsoftware.com/downloads/opensource/appdev/linux-x11-cpp;
    description = "A cross-platform application framework for C++";
  };
}
