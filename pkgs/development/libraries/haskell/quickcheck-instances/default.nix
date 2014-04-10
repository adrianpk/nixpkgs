{ cabal, hashable, QuickCheck, text, time, unorderedContainers }:

cabal.mkDerivation (self: {
  pname = "quickcheck-instances";
  version = "0.3.8";
  sha256 = "0132a37zi1haz1aaggxa1hr421bcmxlbaa4m2l53m2rmr4z5mgkg";
  buildDepends = [
    hashable QuickCheck text time unorderedContainers
  ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/aslatter/qc-instances";
    description = "Common quickcheck instances";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
