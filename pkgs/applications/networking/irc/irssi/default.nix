{ stdenv, fetchurl, pkgconfig, ncurses, glib, openssl, perl, libintlOrEmpty }:

stdenv.mkDerivation rec {
  version = "1.1.0";
  name = "irssi-${version}";

  src = fetchurl {
    url = "https://github.com/irssi/irssi/releases/download/${version}/${name}.tar.gz";
    sha256 = "0y362v6ncgs77q5axv7vgjm6vcxiaj5chsxj1ha07jaxsr1z7285";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ncurses glib openssl perl libintlOrEmpty ];

  configureFlags = [
    "--with-proxy"
    "--with-bot"
    "--with-perl=yes"
    "--enable-true-color"
  ];

  meta = {
    homepage    = http://irssi.org;
    description = "A terminal based IRC client";
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ lovek323 ];
  };
}
