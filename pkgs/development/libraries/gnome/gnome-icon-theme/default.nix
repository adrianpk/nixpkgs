{input, stdenv, fetchurl, pkgconfig, perl, perlXMLParser}:

assert pkgconfig != null && perl != null;

stdenv.mkDerivation {
  inherit (input) name src;
  buildInputs = [pkgconfig perl perlXMLParser];

  # TODO: maybe this package as dependency on gnome-themes?
  configureFlags = "--disable-hicolor-check";

  PERL5LIB = perlXMLParser ~ "/lib/site_perl";
}
