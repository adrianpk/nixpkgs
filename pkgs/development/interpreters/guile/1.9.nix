{ fetchurl, stdenv, libtool, readline, gmp, pkgconfig, boehmgc, libunistring
, libffi, gawk, makeWrapper, coverageAnalysis ? null }:

# Do either a coverage analysis build or a standard build.
(if coverageAnalysis != null
 then coverageAnalysis
 else stdenv.mkDerivation)

rec {
  name = "guile-1.9.14";  # This is a beta release!

  src = fetchurl {
    url = "ftp://alpha.gnu.org/gnu/guile/${name}.tar.gz";
    sha256 = "16239r7racjjv8pjvmcg4jzsxz1s54rwfj4lqwf6qbignj0gnga0";
  };

  buildInputs =
    [ makeWrapper gawk readline libtool libunistring
      libffi pkgconfig
    ];
  propagatedBuildInputs = [ gmp boehmgc ]

    # XXX: These ones aren't normally needed here, but since
    # `libguile-2.0.la' reads `-lltdl -lunistring', adding them here will add
    # the needed `-L' flags.  As for why the `.la' file lacks the `-L' flags,
    # see below.
    ++ [ libtool libunistring ];

  patches =
    stdenv.lib.optionals (coverageAnalysis != null)
      [ ./gcov-file-name.patch ./disable-gc-sensitive-tests.patch ];

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
    description = "GNU Guile 1.9 (beta), an embeddable Scheme implementation";

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
