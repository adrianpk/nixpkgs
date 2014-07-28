# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, binary, deepseq, erf, HUnit, ieee754, mathFunctions
, monadPar, mwcRandom, primitive, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, vector
, vectorAlgorithms, vectorBinaryInstances
}:

cabal.mkDerivation (self: {
  pname = "statistics";
  version = "0.13.1.1";
  sha256 = "1ghb2snbacbfzxqcrvdiihvw2iip1m8rq9y62x1ayg6k13agm7r5";
  buildDepends = [
    aeson binary deepseq erf mathFunctions monadPar mwcRandom primitive
    vector vectorAlgorithms vectorBinaryInstances
  ];
  testDepends = [
    binary erf HUnit ieee754 mathFunctions mwcRandom primitive
    QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2 vector vectorAlgorithms
  ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/bos/statistics";
    description = "A library of statistical types, data, and functions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
