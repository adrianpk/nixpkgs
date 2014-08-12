# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, async, HUnit, liftedBase, monadControl, mtl, tasty
, tastyHunit, tastyTh, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "lifted-async";
  version = "0.2.0.1";
  sha256 = "1x3qdgy0jkqx71xndjh769lw3wrwq63k2kc33pxn6x11yyklcf1j";
  buildDepends = [ async liftedBase monadControl transformersBase ];
  testDepends = [
    async HUnit liftedBase monadControl mtl tasty tastyHunit tastyTh
  ];
  meta = {
    homepage = "https://github.com/maoe/lifted-async";
    description = "Run lifted IO operations asynchronously and wait for their results";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
