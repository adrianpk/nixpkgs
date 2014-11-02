# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, active, colour, dataDefaultClass, diagramsCore, dualTree
, filepath, fingertree, hashable, intervals, JuicyPixels, lens
, MemoTrie, monoidExtras, optparseApplicative, semigroups, tagged
, vectorSpace, vectorSpacePoints
}:

cabal.mkDerivation (self: {
  pname = "diagrams-lib";
  version = "1.2.0.4";
  sha256 = "01gcbgxsnrcsysvpjhprym5ix10350x7l57f28nm0hbrfrsgidhz";
  buildDepends = [
    active colour dataDefaultClass diagramsCore dualTree filepath
    fingertree hashable intervals JuicyPixels lens MemoTrie
    monoidExtras optparseApplicative semigroups tagged vectorSpace
    vectorSpacePoints
  ];
  jailbreak = true;
  meta = {
    homepage = "http://projects.haskell.org/diagrams";
    description = "Embedded domain-specific language for declarative graphics";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ bergey ];
  };
})
