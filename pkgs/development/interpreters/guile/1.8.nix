{ stdenv, buildPackages
, buildPlatform, hostPlatform
, fetchurl, makeWrapper, gawk, pkgconfig
, libtool, readline, gmp
}:

stdenv.mkDerivation rec {
  name = "guile-1.8.8";

  src = fetchurl {
    url = "mirror://gnu/guile/${name}.tar.gz";
    sha256 = "0l200a0v7h8bh0cwz6v7hc13ds39cgqsmfrks55b1rbj5vniyiy3";
  };

  outputs = [ "out" "dev" "info" ];
  setOutputFlags = false; # $dev gets into the library otherwise

  # GCC 4.6 raises a number of set-but-unused warnings.
  configureFlags = [ "--disable-error-on-warning" ];

  depsBuildBuild = [ buildPackages.stdenv.cc ]
    ++ stdenv.lib.optional (hostPlatform != buildPlatform)
                           buildPackages.buildPackages.guile_1_8;
  nativeBuildInputs = [ makeWrapper gawk pkgconfig ];
  buildInputs = [ readline libtool ];

  propagatedBuildInputs = [ gmp ];

  patches = [ ./cpp-4.5.patch ];


  postInstall = ''
    wrapProgram $out/bin/guile-snarf --prefix PATH : "${gawk}/bin"
  '';

  preBuild = ''
    sed -e '/lt_dlinit/a  lt_dladdsearchdir("'$out/lib'");' -i libguile/dynl.c
  '';

  # Guile needs patching to preset results for the configure tests
  # about pthreads, which work only in native builds.
  preConfigure = ''
    if test -n "$crossConfig"; then
      configureFlags="--with-threads=no $configureFlags"
    fi
  '';

  # One test fails.
  # ERROR: file: "libtest-asmobs", message: "file not found"
  # This is fixed here:
  # <http://git.savannah.gnu.org/cgit/guile.git/commit/?h=branch_release-1-8&id=a0aa1e5b69d6ef0311aeea8e4b9a94eae18a1aaf>.
  doCheck = false;

  setupHook = ./setup-hook.sh;

  meta = {
    description = "Embeddable Scheme implementation";
    homepage    = http://www.gnu.org/software/guile/;
    license     = stdenv.lib.licenses.lgpl2Plus;
    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms   = stdenv.lib.platforms.unix;

    longDescription = ''
      GNU Guile is an interpreter for the Scheme programming language,
      packaged as a library that can be embedded into programs to make
      them extensible.  It supports many SRFIs.
    '';
  };
}
