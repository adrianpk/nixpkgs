{ cabal, dataDefault, vector }:

cabal.mkDerivation (self: {
  pname = "vector-th-unbox";
  version = "0.2.1.0";
  sha256 = "0r8yxj63hvkm923y8mk1b5kv1b15lqadxhlncc02glvmy8zf1prh";
  buildDepends = [ vector ];
  testDepends = [ dataDefault vector ];
  meta = {
    description = "Deriver for Data.Vector.Unboxed using Template Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
