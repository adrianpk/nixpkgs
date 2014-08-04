# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, random, transformers, utilityHt }:

cabal.mkDerivation (self: {
  pname = "probability";
  version = "0.2.4.1";
  sha256 = "0nh73l03d7niz3a3h2y4i80mlp64ilfkx7krn57skzfi8drwnjvc";
  buildDepends = [ random transformers utilityHt ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Probabilistic_Functional_Programming";
    description = "Probabilistic Functional Programming";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
