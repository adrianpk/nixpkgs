{ cabal, binary, hashable, QuickCheck, testFramework
, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "concrete-typerep";
  version = "0.1.0.2";
  sha256 = "07wy8drg4723zdy2172jrcvd5ir2c4ggcfz1n33jhm9iv3cl2app";
  buildDepends = [ binary hashable ];
  testDepends = [
    binary hashable QuickCheck testFramework testFrameworkQuickcheck2
  ];
  meta = {
    description = "Binary and Hashable instances for TypeRep";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
