{ fetchurl, stdenv, libtool, readline, gmp, pkgconfig, boehmgc, libunistring
, gawk, makeWrapper }:

stdenv.mkDerivation rec {
  name = "guile-1.9.4";  # This is an alpha release!
  src = fetchurl {
    url = "ftp://alpha.gnu.org/gnu/guile/${name}.tar.gz";
    sha256 = "1p136fb0s46q1cycfsnd7nny14ji43xva58cz39szvq36p9kjbbg";
  };

  buildInputs = [ makeWrapper gawk readline libtool libunistring pkgconfig ];
  propagatedBuildInputs = [ gmp boehmgc ];

  postInstall = ''
    wrapProgram $out/bin/guile-snarf --prefix PATH : "${gawk}/bin"

    # XXX: See http://thread.gmane.org/gmane.comp.lib.gnulib.bugs/18903 for
    # why `--with-libunistring-prefix' and similar options coming from
    # `AC_LIB_LINKFLAGS_BODY' don't work on NixOS/x86_64.
    sed -i "$out/lib/pkgconfig/guile-2.0.pc"    \
        -e 's|-lunistring|-L${libunistring}/lib -lunistring|g ;
            s|^Cflags:\(.*\)$|Cflags: -I${libunistring}/include \1|g ;
            s|-lltdl|-L${libtool}/lib -lltdl|g'
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
