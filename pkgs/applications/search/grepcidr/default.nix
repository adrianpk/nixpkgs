{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "grepcidr-${version}";
  version = "2.0";

  src = fetchurl {
    url = "http://www.pc-tools.net/files/unix/${name}.tar.gz";
    sha256 = "1yzpa1nigmmp4hir6377hrkpp0z6jnxgccaw2jbqgydbglvnm231";
  };

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Filter IPv4 and IPv6 addresses matching CIDR patterns";
    homepage = http://www.pc-tools.net/unix/grepcidr/;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.fadenb ];
  };
}
