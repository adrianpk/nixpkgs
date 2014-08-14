# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "mtl";
  version = "2.1.1";
  sha256 = "143s0c5hygwnd72x14jwinpnd92gx4y9blhmv6086rxijqbq6l4j";
  buildDepends = [ transformers ];
  meta = {
    description = "Monad classes, using functional dependencies";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    hydraPlatforms = self.stdenv.lib.platforms.none;
  };
})
