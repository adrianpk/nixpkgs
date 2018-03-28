{ stdenv, fetchurl, pkgconfig, glib, babl, libpng, cairo, libjpeg, which
, librsvg, pango, gtk, bzip2, json-glib, intltool, autoreconfHook, libraw
, libwebp, gnome3, libintl }:

stdenv.mkDerivation rec {
  name = "gegl-0.3.30";

  src = fetchurl {
    url = "http://download.gimp.org/pub/gegl/0.3/${name}.tar.bz2";
    sha256 = "0lg5j5kn24qvyb6fn7khxf3jadkacbpnb9nrqzy7w665s8xakd7q";
  };

  hardeningDisable = [ "format" ];

  # needs fonts otherwise  don't know how to pass them
  configureFlags = "--disable-docs";

  enableParallelBuilding = true;

  doCheck = true;

  buildInputs = [
    libpng cairo libjpeg librsvg pango gtk bzip2
    libraw libwebp gnome3.gexiv2
  ];

  propagatedBuildInputs = [ glib json-glib babl ]; # for gegl-3.0.pc

  nativeBuildInputs = [ pkgconfig intltool which autoreconfHook libintl ];

  meta = with stdenv.lib; {
    description = "Graph-based image processing framework";
    homepage = http://www.gegl.org;
    license = licenses.gpl3;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
