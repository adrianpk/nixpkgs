# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, dlist, doctest, either, filepath, free, lens, mmorph
, monadControl, mtl, optparseApplicative, randomShuffle, split, stm
, tagged, tasty, temporary, text, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "hcltest";
  version = "0.3.5";
  sha256 = "00y8bd50q6yby2zab00vryallgdndqiabg3idvzmfka0z7fmsqvl";
  buildDepends = [
    dlist either filepath free lens mmorph monadControl mtl
    optparseApplicative randomShuffle split stm tagged tasty temporary
    text transformers transformersBase
  ];
  testDepends = [ doctest filepath ];
  meta = {
    homepage = "http://github.com/bennofs/hcltest/";
    description = "A testing library for command line applications";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
