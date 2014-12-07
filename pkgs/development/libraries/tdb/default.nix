{ stdenv, fetchurl, python27, pkgconfig, gettext, readline, libxslt
, docbook_xsl, docbook_xml_dtd_42
, libaio ? null, acl ? null, heimdal ? null, libcap ? null, sasl ? null, pam ? null, zlib ? null
, libgcrypt ? null
}:

stdenv.mkDerivation rec {
  name = "tdb-1.3.3";

  src = fetchurl {
    url = "http://samba.org/ftp/tdb/${name}.tar.gz";
    sha256 = "03jg7gvyi5ljj93zwvqw1d1p7a9gqy0v4rxwn7ypw4ipxyiavpjl";
  };

  buildInputs = [
    python27 pkgconfig gettext readline libxslt docbook_xsl docbook_xml_dtd_42
    libaio acl heimdal libcap sasl pam zlib libgcrypt
  ];

  preConfigure = ''
    sed -i 's,#!/usr/bin/env python,#!${python27}/bin/python,g' buildtools/bin/waf
  '';

  configureFlags = [
    "--bundled-libraries=NONE"
    "--builtin-libraries=replace"
  ];

  meta = with stdenv.lib; {
    description = "The trivial database";
    longDescription =
      '' TDB is a Trivial Database. In concept, it is very much like GDBM,
         and BSD's DB except that it allows multiple simultaneous writers and
         uses locking internally to keep writers from trampling on each
         other.  TDB is also extremely small.
      '';
    homepage = http://tdb.samba.org/;
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.all;
  };
}
