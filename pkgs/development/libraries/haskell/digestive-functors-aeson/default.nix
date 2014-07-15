# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, digestiveFunctors, HUnit, lens, mtl, safe
, scientific, tasty, tastyHunit, text, vector
}:

cabal.mkDerivation (self: {
  pname = "digestive-functors-aeson";
  version = "1.1.10";
  sha256 = "0ar165rksnj09sb58qx5hm71kn8gzm936ixmfhf7sqbw2kcbw4nx";
  buildDepends = [ aeson digestiveFunctors lens safe text vector ];
  testDepends = [
    aeson digestiveFunctors HUnit mtl scientific tasty tastyHunit text
  ];
  meta = {
    homepage = "http://github.com/ocharles/digestive-functors-aeson";
    description = "Run digestive-functors forms against JSON";
    license = self.stdenv.lib.licenses.gpl3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
