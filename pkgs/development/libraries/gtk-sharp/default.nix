{ stdenv, fetchurl, pkgconfig, mono
, glib
, pango
, gtk
, gconf ? null
, libglade ? null
, libgtkhtml ? null
, gtkhtml ? null
, libgnomecanvas ? null
, libgnomeui ? null
, libgnomeprint ? null
, libgnomeprintui ? null
, libxml2 } :

stdenv.mkDerivation {
  name = "gtk-sharp-1.0.6";

  src = fetchurl {
    url = http://www.go-mono.com/archive/1.0.6/gtk-sharp-1.0.6.tar.gz;
    md5 = "2651d14fe77174ab20b8af53d150ee11";
  };

  buildInputs = [

    pkgconfig mono glib pango gtk gconf libglade libgnomecanvas
    libgtkhtml libgnomeui libgnomeprint libgnomeprintui gtkhtml libxml2

  ];
}


