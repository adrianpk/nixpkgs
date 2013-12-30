{ cabal, HUnit, testFramework, testFrameworkHunit, text }:

cabal.mkDerivation (self: {
  pname = "minimorph";
  version = "0.1.5.0";
  sha256 = "00dnvv0pap2xr74xwzldz89783iw320z7p1rdw0lwjjpbqa3v00g";
  buildDepends = [ text ];
  testDepends = [ HUnit testFramework testFrameworkHunit text ];
  meta = {
    homepage = "http://darcsden.com/kowey/minimorph";
    description = "English spelling functions with an emphasis on simplicity";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
