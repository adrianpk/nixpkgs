# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, binary, parsec }:

cabal.mkDerivation (self: {
  pname = "bencode";
  version = "0.5";
  sha256 = "018cj7h5llvnqyr1jd9nif2ig9hz8d8vmi9iax07all567yhy378";
  buildDepends = [ binary parsec ];
  meta = {
    description = "Parser and printer for bencoded data";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
