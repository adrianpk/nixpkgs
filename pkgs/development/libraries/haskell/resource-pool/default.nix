{ cabal, hashable, monadControl, stm, time, transformers
, transformersBase, vector
}:

cabal.mkDerivation (self: {
  pname = "resource-pool";
  version = "0.2.3.0";
  sha256 = "15igbvnqs6ig1k30l3jngyi60ay7k15mwgza5smv8zbpx86vb1mh";
  buildDepends = [
    hashable monadControl stm time transformers transformersBase vector
  ];
  meta = {
    homepage = "http://github.com/bos/pool";
    description = "A high-performance striped resource pooling implementation";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
