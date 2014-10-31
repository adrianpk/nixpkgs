# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, bifunctors, comonad, contravariant, deepseq, distributive
, doctest, exceptions, filepath, free, genericDeriving, hashable
, hlint, HUnit, mtl, nats, parallel, primitive, profunctors
, QuickCheck, reflection, semigroupoids, semigroups, simpleReflect
, split, tagged, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, testFrameworkTh, text, transformers
, transformersCompat, unorderedContainers, vector, void
}:

cabal.mkDerivation (self: {
  pname = "lens";
  version = "4.5";
  sha256 = "009wdzybzmk7cs27fzigsmxknim6f9s7lp7iivgcsfn49pd8imwv";
  buildDepends = [
    bifunctors comonad contravariant distributive exceptions filepath
    free hashable mtl parallel primitive profunctors reflection
    semigroupoids semigroups split tagged text transformers
    transformersCompat unorderedContainers vector void
  ];
  testDepends = [
    deepseq doctest filepath genericDeriving hlint HUnit mtl nats
    parallel QuickCheck semigroups simpleReflect split testFramework
    testFrameworkHunit testFrameworkQuickcheck2 testFrameworkTh text
    transformers unorderedContainers vector
  ];
  meta = {
    homepage = "http://github.com/ekmett/lens/";
    description = "Lenses, Folds and Traversals";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
