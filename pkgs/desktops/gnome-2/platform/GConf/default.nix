{ stdenv, fetchurl, pkgconfig, dbus-glib, glib, ORBit2, libxml2
, polkit, intltool, dbus, gtk2 ? null, withGtk ? false }:


stdenv.mkDerivation rec {
  name = "gconf-${version}";
  version = "3.2.6";

  src = fetchurl {
    url = "mirror://gnome/sources/GConf/${stdenv.lib.versions.majorMinor version}/GConf-${version}.tar.xz";
    sha256 = "0k3q9nh53yhc9qxf1zaicz4sk8p3kzq4ndjdsgpaa2db0ccbj4hr";
  };

  outputs = [ "out" "dev" "man" ];

  buildInputs = [ ORBit2 dbus dbus-glib libxml2 ]

    # polkit requires pam, which requires shadow.h, which is not available on
    # darwin
    ++ stdenv.lib.optional (!stdenv.isDarwin) polkit;

  propagatedBuildInputs = [ glib dbus-glib ];

  nativeBuildInputs = [ pkgconfig intltool ];

  configureFlags =
    # fixes the "libgconfbackend-oldxml.so is not portable" error on darwin
    stdenv.lib.optional stdenv.isDarwin [ "--enable-static" ];

  meta = with stdenv.lib; {
    homepage = https://projects.gnome.org/gconf/;
    description = "Deprecated system for storing application preferences";
    platforms = platforms.linux;
  };
}
