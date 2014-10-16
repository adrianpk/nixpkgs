# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, binary, dataDefault, deepseq, fingertree, hspec
, QuickCheck, quickcheckInstances, text
}:

cabal.mkDerivation (self: {
  pname = "yi-rope";
  version = "0.4.1.0";
  sha256 = "11k0fl2m6m7idvanfrgvl3h068i6yj6rzxmwpjylz4vdqq618rcq";
  buildDepends = [ binary dataDefault deepseq fingertree text ];
  testDepends = [ hspec QuickCheck quickcheckInstances text ];
  meta = {
    description = "A rope data structure used by Yi";
    license = self.stdenv.lib.licenses.gpl2;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ fuuzetsu ];
  };
})
