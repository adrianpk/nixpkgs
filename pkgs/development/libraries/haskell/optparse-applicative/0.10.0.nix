# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, ansiWlPprint, transformers, transformersCompat }:

cabal.mkDerivation (self: {
  pname = "optparse-applicative";
  version = "0.10.0";
  sha256 = "04hr6rzgc8h0c8fy748as3q7sc8vm94gvk0rw4gdj605z8hvaxcb";
  buildDepends = [ ansiWlPprint transformers transformersCompat ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/pcapriotti/optparse-applicative";
    description = "Utilities and combinators for parsing command line options";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    hydraPlatforms = self.stdenv.lib.platforms.none;
  };
})
