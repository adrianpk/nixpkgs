# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, mtl, text }:

cabal.mkDerivation (self: {
  pname = "boomerang";
  version = "1.4.5";
  sha256 = "03iaasyg2idvq25wzzjk2yr9lyql7bcgmfkycy1cy4ms5dg91k6q";
  buildDepends = [ mtl text ];
  meta = {
    description = "Library for invertible parsing and printing";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
