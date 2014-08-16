# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, mtl, transformers }:

cabal.mkDerivation (self: {
  pname = "fclabels";
  version = "2.0.2";
  sha256 = "108ad6l8ibz44n000hlywqpqslsz1czmsal7qvbd53chmmm4xgdp";
  buildDepends = [ mtl transformers ];
  meta = {
    homepage = "https://github.com/sebastiaanvisser/fclabels";
    description = "First class accessor labels implemented as lenses";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
