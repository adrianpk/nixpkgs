# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, exceptions, hspec, liftedBase, mmorph, monadControl, mtl
, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "resourcet";
  version = "1.1.3.3";
  sha256 = "0ih5p1k0n3ylcv0yk5x7hjzbzhs67vxmng708g9vz7a24xs2m7w2";
  buildDepends = [
    exceptions liftedBase mmorph monadControl mtl transformers
    transformersBase
  ];
  testDepends = [ hspec liftedBase transformers ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Deterministic allocation and freeing of scarce resources";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
