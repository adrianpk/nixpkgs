{ cabal, primitive, random, time }:

cabal.mkDerivation (self: {
  pname = "tf-random";
  version = "0.5";
  sha256 = "0445r2nns6009fmq0xbfpyv7jpzwv0snccjdg7hwj4xk4z0cwc1f";
  buildDepends = [ primitive random time ];
  meta = {
    description = "High-quality splittable pseudorandom number generator";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
