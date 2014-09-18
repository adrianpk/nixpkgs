# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, ansiWlPprint, binary, cassava, deepseq, either
, filepath, Glob, hastache, HUnit, mtl, mwcRandom
, optparseApplicative, parsec, QuickCheck, statistics
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2, text
, time, transformers, vector, vectorAlgorithms
}:

cabal.mkDerivation (self: {
  pname = "criterion";
  version = "1.0.1.0";
  sha256 = "1mp4rm6jd8g38yyhfrxk1xzhp6mxrwwns9kl6494ylsdpsv0v4ll";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson ansiWlPprint binary cassava deepseq either filepath Glob
    hastache mtl mwcRandom optparseApplicative parsec statistics text
    time transformers vector vectorAlgorithms
  ];
  testDepends = [
    HUnit QuickCheck statistics testFramework testFrameworkHunit
    testFrameworkQuickcheck2 vector
  ];
  doCheck = false;
  meta = {
    homepage = "http://www.serpentine.com/criterion";
    description = "Robust, reliable performance measurement and analysis";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
