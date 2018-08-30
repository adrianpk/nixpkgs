{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "thttpd-${version}";
  version = "2.29";

  src = fetchurl {
    url = "https://acme.com/software/thttpd/${name}.tar.gz";
    sha256 = "15x3h4b49wgfywn82i3wwbf38mdns94mbi4ma9xiwsrjv93rzh4r";
  };

  prePatch = ''
    sed -i -e 's/getline/getlineX/' extras/htpasswd.c
    sed -i -e 's/chmod 2755/chmod 755/' extras/Makefile.in
  '';

  preInstall = ''
    mkdir -p "$out/man/man1"
    sed -i -e 's/-o bin -g bin *//' Makefile
    sed -i -e '/chgrp/d' extras/Makefile
  '';

  meta = {
    description = "Tiny/turbo/throttling HTTP server";
    homepage = http://www.acme.com/software/thttpd/;
    license = stdenv.lib.licenses.bsd2;
    platforms = stdenv.lib.platforms.linux;
  };
}
