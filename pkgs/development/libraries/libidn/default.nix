{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "libidn-1.18";

  src = fetchurl {
    url = "mirror://gnu/libidn/${name}.tar.gz";
    sha256 = "0z77jrbpw8j5irdmbr39ffm1n2l2mnihhwlvwjia2jwz660yy95q";
  };

  doCheck = true;

  meta = {
    homepage = http://www.gnu.org/software/libidn/;
    description = "GNU Libidn library for internationalized domain names";

    longDescription = ''
      GNU Libidn is a fully documented implementation of the
      Stringprep, Punycode and IDNA specifications.  Libidn's purpose
      is to encode and decode internationalized domain names.  The
      native C, C\# and Java libraries are available under the GNU
      Lesser General Public License version 2.1 or later.

      The library contains a generic Stringprep implementation.
      Profiles for Nameprep, iSCSI, SASL, XMPP and Kerberos V5 are
      included.  Punycode and ASCII Compatible Encoding (ACE) via IDNA
      are supported.  A mechanism to define Top-Level Domain (TLD)
      specific validation tables, and to compare strings against those
      tables, is included.  Default tables for some TLDs are also
      included.
    '';

    license = "LGPLv2+";
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
