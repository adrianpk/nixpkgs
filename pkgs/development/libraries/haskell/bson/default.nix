# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, binary, cryptohash, dataBinaryIeee754, mtl, network
, QuickCheck, testFramework, testFrameworkQuickcheck2, text, time
}:

cabal.mkDerivation (self: {
  pname = "bson";
  version = "0.3.1";
  sha256 = "1kihsjws8sqb44gvilh1zxrqn2bml8gxq2bbanxqb7nr4ymwfkiv";
  buildDepends = [
    binary cryptohash dataBinaryIeee754 mtl network text time
  ];
  testDepends = [
    binary cryptohash dataBinaryIeee754 mtl network QuickCheck
    testFramework testFrameworkQuickcheck2 text time
  ];
  doCheck = false;
  meta = {
    homepage = "http://github.com/mongodb-haskell/bson";
    description = "BSON documents are JSON-like objects with a standard binary encoding";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
  };
})
