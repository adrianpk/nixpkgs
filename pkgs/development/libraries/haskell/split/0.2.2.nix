# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, QuickCheck }:

cabal.mkDerivation (self: {
  pname = "split";
  version = "0.2.2";
  sha256 = "0xa3j0gwr6k5vizxybnzk5fgb3pppgspi6mysnp2gwjp2dbrxkzr";
  testDepends = [ QuickCheck ];
  doCheck = self.stdenv.lib.versionOlder self.ghc.version "7.9";
  meta = {
    description = "Combinator library for splitting lists";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
