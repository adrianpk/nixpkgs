{ cabal }:

cabal.mkDerivation (self: {
  pname = "regular";
  version = "0.3.4.3";
  sha256 = "12pc58agqb4fi0riwxjf0kykn1z12273q8dcdd0fh2x1ddxwgg2r";
  meta = {
    description = "Generic programming library for regular datatypes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
