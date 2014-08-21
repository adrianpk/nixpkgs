# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, perl, QuickCheck }:

cabal.mkDerivation (self: {
  pname = "alex";
  version = "3.0.1";
  sha256 = "1w7s9kzgr4kfh6cyhb4qkvxwy9gcw3xa1d2k5dy575k3wk73awkj";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ QuickCheck ];
  buildTools = [ perl ];
  doCheck = false;
  meta = {
    homepage = "http://www.haskell.org/alex/";
    description = "Alex is a tool for generating lexical analysers in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    hydraPlatforms = self.stdenv.lib.platforms.none;
  };
})
