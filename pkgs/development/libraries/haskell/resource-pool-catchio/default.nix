{ cabal, hashable, MonadCatchIOTransformers, stm, time
, transformers, transformersBase, vector
}:

cabal.mkDerivation (self: {
  pname = "resource-pool-catchio";
  version = "0.2.1.0";
  sha256 = "0g9r6hnn01n3p2ikcfkfc4afh83pzam29zal3k2ivajpl3kramsw";
  buildDepends = [
    hashable MonadCatchIOTransformers stm time transformers
    transformersBase vector
  ];
  meta = {
    homepage = "http://github.com/norm2782/pool";
    description = "Fork of resource-pool, with a MonadCatchIO constraint";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
