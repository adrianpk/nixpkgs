{ stdenv, fetchFromGitHub, pkgconfig, intltool, libtool, gnome3, bamf,
  json-glib, libcanberra-gtk3, libxkbcommon, libstartup_notification,
  deepin-wallpapers, deepin-desktop-schemas, deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "deepin-metacity";
  version = "3.22.22";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0gr10dv8vphla6z7zqiyyg3n3ag4rrlz43c4kr7fd5xwx2bfvp3d";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    libtool
    gnome3.gnome-common
    gnome3.glib.dev
  ];

  buildInputs = [
    gnome3.dconf
    gnome3.gtk
    gnome3.libgtop
    gnome3.zenity
    bamf
    json-glib
    libcanberra-gtk3
    libstartup_notification
    libxkbcommon
    deepin-wallpapers
    deepin-desktop-schemas
  ];

  postPatch = ''
    sed -i src/ui/deepin-background-cache.c \
      -e 's;/usr/share/backgrounds/default_background.jpg;${deepin-wallpapers}/share/backgrounds/deepin/desktop.jpg;'
  '';

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib.dev}/include/gio-unix-2.0";

  configureFlags = [ "--disable-themes-documentation" ];

  preConfigure = ''
    HOME=$TMP
    NOCONFIGURE=1 ./autogen.sh
  '';

  enableParallelBuilding = true;

  passthru.updateScript = deepin.updateScript { inherit name; };

  meta = with stdenv.lib; {
    description = "2D window manager for Deepin";
    homepage = https://github.com/linuxdeepin/deepin-metacity;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
