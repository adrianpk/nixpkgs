{ stdenv, fetchurl, pkgconfig, python, libxml2Python, libxslt, which, libX11, gnome3, gtk3, glib
, intltool, gnome_doc_utils, libxkbfile, xkeyboard_config, isocodes, itstool, wayland
, libseccomp, gobjectIntrospection }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  # this should probably be setuphook for glib
  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkgconfig which itstool intltool libxslt gnome_doc_utils gobjectIntrospection
  ];
  buildInputs = [ python libxml2Python libX11
                  xkeyboard_config isocodes wayland
                  gtk3 glib libxkbfile libseccomp ];

  propagatedBuildInputs = [ gnome3.gsettings_desktop_schemas ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
