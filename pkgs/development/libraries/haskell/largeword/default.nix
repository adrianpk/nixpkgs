{ cabal, binary, HUnit, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "largeword";
  version = "1.2.3";
  sha256 = "1ldcsnnji6p84sn03j17pdcpg7vqn1xrhyn4wys0v5fyy0d383ln";
  buildDepends = [ binary ];
  testDepends = [
    binary HUnit QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2
  ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/idontgetoutmuch/largeword";
    description = "Provides Word128, Word192 and Word256 and a way of producing other large words if required";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
