# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, mtl, random, transformers }:

cabal.mkDerivation (self: {
  pname = "MonadRandom";
  version = "0.3.0.1";
  sha256 = "0bbj6rkxskrvl14lngpggql4q41pw21cj4z8h592mizrxjfa3rj0";
  buildDepends = [ mtl random transformers ];
  meta = {
    description = "Random-number generation monad";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
  };
})
