{ fetchurl, stdenv, pkgconfig, intltool, glib, gtk3
, libgsf, libxml2, libxslt, cairo, pango, librsvg, libspectre }:

stdenv.mkDerivation rec {
  name = "goffice-0.10.36";

  src = fetchurl {
    url = "mirror://gnome/sources/goffice/0.10/${name}.tar.xz";
    sha256 = "cfe65fc0a665538704c7bab8541784291cf0781df8b4cff73cb0a513ee0baad6";
  };

  nativeBuildInputs = [ pkgconfig intltool ];

  propagatedBuildInputs = [ # ToDo lasem library for MathML, opt. introspection?
    glib gtk3 libxml2 cairo pango libgsf
  ];

  buildInputs = [ libxslt librsvg ];

  enableParallelBuilding = true;
  doCheck = true;

  meta = {
    description = "A Glib/GTK+ set of document centric objects and utilities";

    longDescription = ''
      There are common operations for document centric applications that are
      conceptually simple, but complex to implement fully: plugins, load/save
      documents, undo/redo.
    '';

    license = stdenv.lib.licenses.gpl2Plus;

    platforms = stdenv.lib.platforms.unix;
  };
}
