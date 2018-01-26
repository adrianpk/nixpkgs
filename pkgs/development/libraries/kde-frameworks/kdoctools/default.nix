{
  mkDerivation, lib,
  extra-cmake-modules, docbook_xml_dtd_45, docbook5_xsl,
  karchive, ki18n, qtbase,
  perl, perlPackages
}:

mkDerivation {
  name = "kdoctools";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [
    extra-cmake-modules
    # The build system insists on having native Perl.
    perl perlPackages.URI
  ];
  propagatedBuildInputs = [
    # kdoctools at runtime actually needs Perl for the platform kdoctools is
    # running on, not necessarily native perl.
    perl perlPackages.URI
    qtbase
  ];
  buildInputs = [ karchive ki18n ];
  outputs = [ "out" "dev" ];
  patches = [ ./kdoctools-no-find-docbook-xml.patch ];
  cmakeFlags = [
    "-DDocBookXML4_DTD_DIR=${docbook_xml_dtd_45}/xml/dtd/docbook"
    "-DDocBookXSL_DIR=${docbook5_xsl}/xml/xsl/docbook"
  ];
  postFixup = ''
    moveToOutput "share/doc" "$dev"
    moveToOutput "share/man" "$dev"
  '';
}
