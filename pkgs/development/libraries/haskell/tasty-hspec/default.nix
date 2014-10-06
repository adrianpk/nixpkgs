# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, hspec, QuickCheck, random, tasty, tastyQuickcheck
, tastySmallcheck
}:

cabal.mkDerivation (self: {
  pname = "tasty-hspec";
  version = "0.2";
  sha256 = "04qnmsyrlxgxf36lww3z6xkgpf6x5gprwrrwza3kcjl13wcm2rml";
  buildDepends = [
    hspec QuickCheck random tasty tastyQuickcheck tastySmallcheck
  ];
  meta = {
    homepage = "http://github.com/mitchellwrosen/tasty-hspec";
    description = "Hspec support for the Tasty test framework";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ ocharles ];
  };
})
