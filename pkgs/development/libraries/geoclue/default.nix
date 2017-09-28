{ stdenv, fetchurl, dbus, dbus_glib, glib, pkgconfig, libxml2, gnome2,
  libxslt, glib_networking }:

stdenv.mkDerivation rec {
  name = "geoclue-0.12.0";
  src = fetchurl {
    url = "https://launchpad.net/geoclue/trunk/0.12/+download/${name}.tar.gz";
    sha256 = "15j619kvmdgj2hpma92mkxbzjvgn8147a7500zl3bap9g8bkylqg";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libxml2 gnome2.GConf libxslt glib_networking ];

  propagatedBuildInputs = [dbus glib dbus_glib];

  hardeningDisable = [ "format" ];

  preConfigure = ''
    sed -e '/-Werror/d' -i configure
  '';

  meta = with stdenv.lib; {
    description = "Geolocation framework and some data providers";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    license = licenses.lgpl2;
  };

  passthru = {
    updateInfo = {
      downloadPage = "http://folks.o-hand.com/jku/geoclue-releases/";
    };
  };
}
