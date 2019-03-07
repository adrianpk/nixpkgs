{ stdenv, fetchurl, pkgconfig, gettext, glib, libxml2
, libxslt, libarchive, bzip2, lzma, json-glib, perl
}:

stdenv.mkDerivation rec {
  name = "osinfo-db-tools-1.4.0";

  src = fetchurl {
    url = "https://releases.pagure.org/libosinfo/${name}.tar.gz";
    sha256 = "08zpjq1g27n6wmmqwxws95w045warhg9bxcv1phvkdcrddf15q3y";
  };

  nativeBuildInputs = [
    pkgconfig gettext
    perl # for pod2man command
  ];
  buildInputs = [
    glib libxml2 libxslt libarchive bzip2 lzma json-glib
  ];

  meta = with stdenv.lib; {
    description = "Tools for managing the osinfo database";
    homepage = https://libosinfo.org/;
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
