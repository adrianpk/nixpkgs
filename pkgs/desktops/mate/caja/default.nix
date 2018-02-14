{ stdenv, fetchurl, pkgconfig, intltool, gtk3, libnotify, libxml2, libexif, exempi, mate, hicolor_icon_theme, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "caja-${version}";
  version = "1.20.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "05shyqqapqbz4w0gbhx0i3kj6xg7rcj80hkaq7wf5pyj91wmkxqg";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    libnotify
    libxml2
    libexif
    exempi
    mate.mate-desktop
    hicolor_icon_theme
  ];

  patches = [
    ./caja-extension-dirs.patch
  ];
  
  configureFlags = [ "--disable-update-mimedb" ];
  
  meta = {
    description = "File manager for the MATE desktop";
    homepage = http://mate-desktop.org;
    license = with stdenv.lib.licenses; [ gpl2 lgpl2 ];
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
