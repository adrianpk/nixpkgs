{ stdenv, fetchurl, libsodium, pkgconfig, systemd }:

stdenv.mkDerivation rec {
  name = "dnscrypt-proxy-1.4.3";

  src = fetchurl {
    url = "http://download.dnscrypt.org/dnscrypt-proxy/${name}.tar.bz2";
    sha256 = "0cij80ryxnikpmm6s79c2fqg6bdiz1wdy50xrnd7w954vw9mhr0b";
  };

  configureFlags = ''
    ${stdenv.lib.optionalString stdenv.isLinux "--with-systemd"}
  '';

  buildInputs = [ pkgconfig libsodium ] ++ stdenv.lib.optional stdenv.isLinux systemd;

  meta = {
    description = "A tool for securing communications between a client and a DNS resolver";
    homepage = http://dnscrypt.org/;
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ joachifm ];
    platforms = stdenv.lib.platforms.all;
  };
}
