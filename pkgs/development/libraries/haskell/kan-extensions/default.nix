# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, adjunctions, comonad, contravariant, distributive, free
, mtl, pointed, semigroupoids, tagged, transformers
}:

cabal.mkDerivation (self: {
  pname = "kan-extensions";
  version = "4.1.0.1";
  sha256 = "1jrs5cp5bhv3sjfi3d2zl16x40fr086zadp69r8yigj43bgkwkkd";
  buildDepends = [
    adjunctions comonad contravariant distributive free mtl pointed
    semigroupoids tagged transformers
  ];
  meta = {
    homepage = "http://github.com/ekmett/kan-extensions/";
    description = "Kan extensions, Kan lifts, various forms of the Yoneda lemma, and (co)density (co)monads";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
