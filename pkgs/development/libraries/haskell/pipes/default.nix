{ cabal, mmorph, mtl, QuickCheck, testFramework
, testFrameworkQuickcheck2, transformers
}:

cabal.mkDerivation (self: {
  pname = "pipes";
  version = "4.1.2";
  sha256 = "0prxk4qjdcmxjdvpi1bwql0s3l1kwlaz9sydr9swa8bc8ams3a11";
  buildDepends = [ mmorph mtl transformers ];
  testDepends = [
    mtl QuickCheck testFramework testFrameworkQuickcheck2 transformers
  ];
  meta = {
    description = "Compositional pipelines";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
