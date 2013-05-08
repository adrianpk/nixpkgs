{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "pwnat-0.3-beta";

  src = fetchurl {
    url = "http://samy.pl/pwnat/${name}.tgz";
    sha256 = "18ihs6wk7zni2w0pqip7i61hyi6n60v5rgj6z7j543fgy4afmmnm";
  };

  installPhase = ''
    ensureDir $out/bin $out/share/pwnat
    cp pwnat $out/bin
    cp README* COPYING* $out/share/pwnat
  '';

  meta = {
    homepage = http://samy.pl/pwnat/;
    description = "ICMP NAT to NAT client-server communication";
    license = "GPLv3+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  }
}
