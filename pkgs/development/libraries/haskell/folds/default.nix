# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, comonad, contravariant, deepseq, doctest, filepath, hlint
, lens, mtl, pointed, profunctors, reflection, semigroupoids
, semigroups, tagged, transformers, vector
}:

cabal.mkDerivation (self: {
  pname = "folds";
  version = "0.6.2";
  sha256 = "13zdmf7szdy9ka5dw0vgzbfmndm7w8fz7ryz5h2z5hsqg9am2qqa";
  buildDepends = [
    comonad contravariant lens pointed profunctors reflection
    semigroupoids tagged transformers vector
  ];
  testDepends = [ deepseq doctest filepath hlint mtl semigroups ];
  enableSplitObjs = false;
  meta = {
    homepage = "http://github.com/ekmett/folds";
    description = "Beautiful Folding";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
