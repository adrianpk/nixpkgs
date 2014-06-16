{ cabal, mtl, QuickCheck, STMonadTrans, testFramework
, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "equivalence";
  version = "0.2.3";
  sha256 = "0dd986y0sn89fparyz6kz9yhzysbqjcp8s99r81ihghg7s9yc743";
  buildDepends = [ mtl STMonadTrans ];
  testDepends = [
    mtl QuickCheck STMonadTrans testFramework testFrameworkQuickcheck2
  ];
  doCheck = false;
  meta = {
    homepage = "https://bitbucket.org/paba/equivalence/";
    description = "Maintaining an equivalence relation implemented as union-find using STT";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
