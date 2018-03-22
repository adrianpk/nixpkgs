{ stdenv, hostPlatform, fetchurl, perl, gettext, LocaleGettext, makeWrapper }:

stdenv.mkDerivation rec {
  name = "help2man-1.47.6";

  src = fetchurl {
    url = "mirror://gnu/help2man/${name}.tar.xz";
    sha256 = "0vz4dlrvy4vc6l7w0a7n668pfa0rdm73wr2gar58wqranyah46yr";
  };

  nativeBuildInputs = [ makeWrapper gettext LocaleGettext ];
  buildInputs = [ perl LocaleGettext ];

  doCheck = false;                                # target `check' is missing

  patches = if hostPlatform.isCygwin then [ ./1.40.4-cygwin-nls.patch ] else null;

  postInstall =
    '' wrapProgram "$out/bin/help2man" \
         --prefix PERL5LIB : "$(echo ${LocaleGettext}/lib/perl*/site_perl)" \
         ${stdenv.lib.optionalString hostPlatform.isCygwin "--prefix PATH : ${gettext}/bin"}
    '';


  meta = with stdenv.lib; {
    description = "Generate man pages from `--help' output";

    longDescription =
      '' help2man produces simple manual pages from the ‘--help’ and
         ‘--version’ output of other commands.
      '';

    homepage = http://www.gnu.org/software/help2man/;

    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ pSub ];
  };
}
