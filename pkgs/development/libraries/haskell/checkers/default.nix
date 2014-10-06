# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, QuickCheck, random }:

cabal.mkDerivation (self: {
  pname = "checkers";
  version = "0.4.1";
  sha256 = "19ndgbivd07vchsqs6z9iqjl2jldbq7h4skqc9acracd9xyq1vdr";
  buildDepends = [ QuickCheck random ];
  meta = {
    description = "Check properties on standard classes and data structures";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
