{ stdenv, fetchurl, libopcodes }:

with stdenv.lib;
stdenv.mkDerivation rec {

  name = "lightning-${version}";
  version = "2.1.2";

  src = fetchurl {
    url = "mirror://gnu/lightning/${name}.tar.gz";
    sha256 = "0sbs2lm8b9in2m8d52zf0x9gpp40x6r7sl6sha92yq3pr78rwa4v";
  };

  buildInputs = stdenv.lib.optional doCheck libopcodes;

  doCheck = true;

  meta = {
    homepage = http://www.gnu.org/software/lightning/;
    description = "Run-time code generation library";
    longDescription = ''
      GNU lightning is a library that generates assembly language code
      at run-time; it is very fast, making it ideal for Just-In-Time
      compilers, and it abstracts over the target CPU, as it exposes
      to the clients a standardized RISC instruction set inspired by
      the MIPS and SPARC chips.
    '';
    maintainers = [ maintainers.AndersonTorres ];
    license = licenses.lgpl3Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
