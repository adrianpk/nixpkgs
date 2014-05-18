{ cabal, HUnit, mtl, QuickCheck, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, text, time
}:

cabal.mkDerivation (self: {
  pname = "digestive-functors";
  version = "0.7.1.1";
  sha256 = "161461y8gil2922gx6kdc59g50ywk9nk74gkxl0yrwvz80a118c9";
  buildDepends = [ mtl text time ];
  testDepends = [
    HUnit mtl QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2 text time
  ];
  jailbreak = true;
  meta = {
    homepage = "http://github.com/jaspervdj/digestive-functors";
    description = "A practical formlet library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
