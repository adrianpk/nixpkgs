{stdenv, fetchurl, libsigsegv, gettext}:

stdenv.mkDerivation {
  name = "clisp-2.33.2";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://belnet.dl.sourceforge.net/sourceforge/clisp/clisp-2.33.2.tar.bz2;
    md5 = "ee4ea316db1e843dcb16094bf500012f";
  };

  inherit libsigsegv gettext;
  buildInputs = [libsigsegv gettext];
}
