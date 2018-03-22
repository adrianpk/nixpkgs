{ stdenv, buildPackages, fetchurl, ncurses, perl, xz, procps, interactive ? false }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "texinfo-5.2";

  src = fetchurl {
    url = "mirror://gnu/texinfo/${name}.tar.xz";
    sha256 = "1njfwh2z34r2c4r0iqa7v24wmjzvsfyz4vplzry8ln3479lfywal";
  };

  # We need a native compiler to build perl XS extensions
  # when cross-compiling.
  depsBuildBuild = [ buildPackages.stdenv.cc perl ];

  buildInputs = [ perl xz.bin ]
    ++ optional interactive ncurses
    ++ optional doCheck procps; # for tests

  configureFlags = [ "PERL=${buildPackages.perl}/bin/perl" ]
    ++ stdenv.lib.optional stdenv.isSunOS "AWK=${gawk}/bin/awk";

  preInstall = ''
    installFlags="TEXMF=$out/texmf-dist";
    installTargets="install install-tex";
  '';

  doCheck = !stdenv.isDarwin;

  meta = {
    homepage = http://www.gnu.org/software/texinfo/;
    description = "The GNU documentation system";
    license = licenses.gpl3Plus;
    platforms = platforms.all;

    longDescription = ''
      Texinfo is the official documentation format of the GNU project.
      It was invented by Richard Stallman and Bob Chassell many years
      ago, loosely based on Brian Reid's Scribe and other formatting
      languages of the time.  It is used by many non-GNU projects as
      well.

      Texinfo uses a single source file to produce output in a number
      of formats, both online and printed (dvi, html, info, pdf, xml,
      etc.).  This means that instead of writing different documents
      for online information and another for a printed manual, you
      need write only one document.  And when the work is revised, you
      need revise only that one document.  The Texinfo system is
      well-integrated with GNU Emacs.
    '';
    branch = "5.2";
  };
}
