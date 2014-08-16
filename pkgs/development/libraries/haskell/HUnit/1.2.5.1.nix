# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, deepseq }:

cabal.mkDerivation (self: {
  pname = "HUnit";
  version = "1.2.5.1";
  sha256 = "0wa4yqgfyrfxzhdyd04xvzi4qaswbg0rrbywz8sxzkp71v91a35w";
  buildDepends = [ deepseq ];
  meta = {
    homepage = "http://hunit.sourceforge.net/";
    description = "A unit testing framework for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    hydraPlatforms = self.stdenv.lib.platforms.none;
  };
})
