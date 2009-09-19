{ fetchurl, stdenv, libtool, readline, gmp, pkgconfig, boehmgc, libunistring
, gawk, makeWrapper }:

stdenv.mkDerivation rec {
  name = "guile-1.9.3";  # This is an alpha release!
  src = fetchurl {
    url = "ftp://alpha.gnu.org/gnu/guile/${name}.tar.gz";
    sha256 = "10q0k4884b68nba272bg1ym4djpvq35r9m8xw444mrh1jqfz9gsj";
  };

  buildInputs = [ makeWrapper gawk readline libtool libunistring pkgconfig ];
  propagatedBuildInputs = [ gmp boehmgc ];

  postInstall = ''
    wrapProgram $out/bin/guile-snarf --prefix PATH : "${gawk}/bin"
  '';

  preBuild = ''
    sed -e '/lt_dlinit/a  lt_dladdsearchdir("'$out/lib'");' -i libguile/dynl.c
  '';

  doCheck = true;

  setupHook = ./setup-hook.sh;

  meta = {
    description = "GNU Guile 1.9 (alpha), an embeddable Scheme implementation";

    longDescription = ''
      GNU Guile is an implementation of the Scheme programming language, with
      support for many SRFIs, packaged for use in a wide variety of
      environments.  In addition to implementing the R5RS Scheme standard,
      Guile includes a module system, full access to POSIX system calls,
      networking support, multiple threads, dynamic linking, a foreign
      function call interface, and powerful string processing.
    '';

    homepage = http://www.gnu.org/software/guile/;
    license = "LGPLv3+";

    maintainers = [ stdenv.lib.maintainers.ludo ];

    platforms = stdenv.lib.platforms.all;
  };
}
