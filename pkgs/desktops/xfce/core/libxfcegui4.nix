{ stdenv, fetchurl, pkgconfig, intltool, gtk
, libxfce4util, xfconf, libglade, libstartup_notification }:

stdenv.mkDerivation rec {
  p_name  = "libxfcegui4";
  ver_maj = "4.10";
  ver_min = "0";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "0cs5im0ib0cmr1lhr5765yliqjfyxvk4kwy8h1l8bn3mj6bzk0ib";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  #TODO: gladeui
  # By default, libxfcegui4 tries to install into libglade's prefix.
  # Install into our own prefix instead.
  preConfigure =
    ''
      configureFlags="--with-libglade-module-path=$out/lib/libglade/2.0"
    '';
  #NOTE: missing keyboard library support is OK according to the mailing-list

  buildInputs =
    [ pkgconfig intltool gtk libxfce4util xfconf libglade
      libstartup_notification
    ];
  preFixup = "rm $out/share/icons/hicolor/icon-theme.cache";

  meta = {
    homepage = http://www.xfce.org/;
    description = "Basic GUI library for Xfce";
    license = stdenv.lib.licenses.lgpl2Plus;
  };
}
