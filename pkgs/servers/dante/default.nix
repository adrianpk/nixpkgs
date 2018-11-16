{ stdenv, fetchurl, pam, libkrb5, cyrus_sasl, miniupnpc }:

stdenv.mkDerivation rec {
  name = "dante-${version}";
  version = "1.4.2";

  src = fetchurl {
    url = "https://www.inet.no/dante/files/${name}.tar.gz";
    sha256 = "1bfafnm445afrmyxvvcl8ckq0p59yzykmr3y8qvryzrscd85g8ms";
  };

  buildInputs = [ pam libkrb5 cyrus_sasl miniupnpc ];

  configureFlags = [
    "--with-libc=libc.so.6"
  ];

  meta = with stdenv.lib; {
    description = "A circuit-level SOCKS client/server that can be used to provide convenient and secure network connectivity.";
    homepage    = "https://www.inet.no/dante/";
    maintainers = [ maintainers.arobyn ];
    license     = licenses.bsdOriginal;
    platforms   = platforms.linux;
  };
}
