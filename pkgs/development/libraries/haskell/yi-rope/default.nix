# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, binary, charsetdetectAe, dataDefault, deepseq, fingertree
, hspec, QuickCheck, quickcheckInstances, text, textIcu
}:

cabal.mkDerivation (self: {
  pname = "yi-rope";
  version = "0.7.0.0";
  sha256 = "123p0m31h8qa53jl2sd646s1hrs5qnb7y82y7bzgg2zny4qqw9a2";
  buildDepends = [
    binary charsetdetectAe dataDefault deepseq fingertree text textIcu
  ];
  testDepends = [ hspec QuickCheck quickcheckInstances text ];
  meta = {
    description = "A rope data structure used by Yi";
    license = self.stdenv.lib.licenses.gpl2;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ fuuzetsu ];
  };
})
