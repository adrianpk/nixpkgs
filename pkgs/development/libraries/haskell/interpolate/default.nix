# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, doctest, haskellSrcMeta, hspec, QuickCheck
, quickcheckInstances, text
}:

cabal.mkDerivation (self: {
  pname = "interpolate";
  version = "0.0.4";
  sha256 = "0yr0pahb07r7p6d7hb4bqafa64a4jkd37bchr6vkan2zbffwcrcm";
  buildDepends = [ haskellSrcMeta ];
  testDepends = [
    doctest haskellSrcMeta hspec QuickCheck quickcheckInstances text
  ];
  meta = {
    description = "String interpolation done right";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
