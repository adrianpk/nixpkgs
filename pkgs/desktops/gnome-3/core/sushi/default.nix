{ stdenv, fetchurl, pkgconfig, meson, gettext, gobject-introspection, glib
, clutter-gtk, clutter-gst, gnome3, gtksourceview, gjs
, webkitgtk, libmusicbrainz5, icu, wrapGAppsHook, gst_all_1
, gdk_pixbuf, librsvg, gtk3, harfbuzz, ninja }:

stdenv.mkDerivation rec {
  name = "sushi-${version}";
  version = "3.31.2";

  src = fetchurl {
    url = "mirror://gnome/sources/sushi/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0c2s1baw6xkii9nvaimb0zfgs8sj5w2aksmj5qddlk9qsapdlfwr";
  };

  nativeBuildInputs = [
    pkgconfig meson ninja gettext gobject-introspection wrapGAppsHook
  ];
  buildInputs = [
    glib gtk3 gnome3.evince icu harfbuzz
    clutter-gtk clutter-gst gjs gtksourceview gdk_pixbuf
    librsvg libmusicbrainz5 webkitgtk
    gst_all_1.gstreamer gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good
  ];

  enableParallelBuilding = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "sushi";
      attrPath = "gnome3.sushi";
    };
  };

  meta = with stdenv.lib; {
    homepage = "https://en.wikipedia.org/wiki/Sushi_(software)";
    description = "A quick previewer for Nautilus";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
