{ stdenv, fetchurl, pkgconfig, intltool, gtk, glib, libid3tag, id3lib, taglib
, libvorbis, libogg, flac, itstool, libxml2
}:

stdenv.mkDerivation rec {
  name = "easytag-${version}";
  version = "2.2.3";

  src = fetchurl {
    url = "mirror://gnome/sources/easytag/2.2/${name}.tar.xz";
    sha256 = "1cxfmr4fr6a75i0ril40nc4kcy0960dc5vfvkfwswzx6d34av77l";
  };

  preConfigure = ''
    # pkg-config v0.23 should be enough.
    sed -i -e '/_pkg_min_version=0.24/s/24/23/' \
           -e 's/have_mp3=no/have_mp3=yes/' \
           -e 's/ID3TAG_DEPS="id3tag"/ID3TAG_DEPS=""/' configure
  '';

  NIX_LDFLAGS = "-lid3tag -lz";

  buildInputs = [
    pkgconfig intltool gtk glib libid3tag id3lib taglib libvorbis libogg flac
    itstool libxml2
  ];

  meta = {
    description = "View and edit tags for various audio files";
    homepage = "http://projects.gnome.org/easytag/";
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
