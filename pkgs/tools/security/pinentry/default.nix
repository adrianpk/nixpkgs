{ fetchurl, stdenv, pkgconfig
, libcap ? null, ncurses ? null, gtk ? null, qt4 ? null
}:

let
  mkFlag = pfxTrue: pfxFalse: cond: name: "--${if cond then pfxTrue else pfxFalse}-${name}";
  mkEnable = mkFlag "enable" "disable";
  mkWith = mkFlag "with" "without";
  hasX = gtk != null || qt4 != null;
in
with stdenv.lib;
stdenv.mkDerivation rec {
  name = "pinentry-0.9.0";

  src = fetchurl {
    url = "mirror://gnupg/pinentry/${name}.tar.bz2";
    sha256 = "1awhajq21hcjgqfxg9czaxg555gij4bba6axrwg8w6lfmc3ml14h";
  };

  buildInputs = [ libcap gtk ncurses qt4 ];

  configureFlags = [
    (mkWith   (libcap != null)  "libcap")
    (mkEnable (ncurses != null) "pinentry-curses")
    (mkEnable true              "pinentry-tty")
    (mkEnable (gtk != null)     "pinentry-gtk2")
    (mkEnable (qt4 != null)     "pinentry-qt4")
  ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    homepage = "http://gnupg.org/aegypten2/";
    description = "GnuPG's interface to passphrase input";
    license = stdenv.lib.licenses.gpl2Plus;

    longDescription = ''
      Pinentry provides a console and a GTK+ GUI that allows users to
      enter a passphrase when `gpg' or `gpg2' is run and needs it.
    '';
  };
}
