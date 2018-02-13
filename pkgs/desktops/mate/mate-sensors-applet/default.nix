{ stdenv, fetchurl, pkgconfig, intltool, itstool, gtk3, libxml2, libxslt, libatasmart, libnotify, dbus_glib, lm_sensors, mate, hicolor_icon_theme, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-sensors-applet-${version}";
  version = "1.18.3";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "1nm68rhp73kgvs7wwsgs5zbvq3lzaanl5s5nnn28saiknjbz1mcx";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    itstool
    wrapGAppsHook
  ];

  # maybe add nvidia-settings later on
  buildInputs = [
    gtk3
    libxml2
    libxslt
    libatasmart
    libnotify
    dbus_glib
    lm_sensors
    mate.mate-panel
    hicolor_icon_theme
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/mate-desktop/mate-sensors-applet;
    description = "MATE panel applet for hardware sensors";
    license = with licenses; [ gpl2Plus ];
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
