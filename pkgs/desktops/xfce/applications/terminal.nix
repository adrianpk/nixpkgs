{ stdenv, fetchurl, pkgconfig, intltool, ncurses, gtk, vte, dbus_glib
, exo, libxfce4util, libxfce4ui
}:

stdenv.mkDerivation rec {
  p_name  = "xfce4-terminal";
  ver_maj = "0.6";
  ver_min = "3";

  src = fetchurl {
    url = "mirror://xfce/src/apps/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "023y0lkfijifh05yz8grimxadqpi98mrivr00sl18nirq8b4fbwi";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  buildInputs = [ pkgconfig intltool exo gtk vte libxfce4util ncurses dbus_glib libxfce4ui ];

  meta = {
    homepage = http://www.xfce.org/projects/terminal;
    description = "A modern terminal emulator primarily for the Xfce desktop environment";
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
