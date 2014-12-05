# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, alex, deepseq, doctest, filepath, happy, hspec, HUnit, mtl
, QuickCheck, temporary
}:

cabal.mkDerivation (self: {
  pname = "BNFC";
  version = "2.7.1";
  sha256 = "1n9l64wzga3i7ifh2k5rwhxp60gb0av5fszygw5mvr31r64cf4fp";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ deepseq filepath mtl ];
  testDepends = [
    deepseq doctest filepath hspec HUnit mtl QuickCheck temporary
  ];
  buildTools = [ alex happy ];
  meta = {
    homepage = "http://bnfc.digitalgrammars.com/";
    description = "A compiler front-end generator";
    license = self.stdenv.lib.licenses.gpl2;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ andres simons ];
  };
})
