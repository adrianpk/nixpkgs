{ stdenv, fetchurl, python, pkgconfig, readline, libxslt
, docbook_xsl, docbook_xml_dtd_42
}:

stdenv.mkDerivation rec {
  name = "talloc-2.1.3";

  src = fetchurl {
    url = "mirror://samba/talloc/${name}.tar.gz";
    sha256 = "1c1c3zs13qyripjwcjpz2hqc3p9p50m5yl95gdrrrvyl49dzg9bs";
  };

  buildInputs = [
    python pkgconfig readline libxslt docbook_xsl docbook_xml_dtd_42
  ];

  preConfigure = ''
    sed -i 's,#!/usr/bin/env python,#!${python}/bin/python,g' buildtools/bin/waf
  '';

  configureFlags = [
    "--enable-talloc-compat1"
    "--bundled-libraries=NONE"
    "--builtin-libraries=replace"
  ];

  postInstall = ''
    ar qf $out/lib/libtalloc.a bin/default/talloc_5.o
  '';

  meta = with stdenv.lib; {
    description = "Hierarchical pool based memory allocator with destructors";
    homepage = http://tdb.samba.org/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.all;
  };
}
