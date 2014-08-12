{ cabal, bifunctors, doctest, filepath, genericDeriving, hashable
, transformers
}:

cabal.mkDerivation (self: {
  pname = "hashable-extras";
  version = "0.2.0.1";
  sha256 = "09y2m0wpim7sl7n9qnkr0miwfsbvb1q8lm6shpcq0jxzxknbag7s";
  buildDepends = [
    bifunctors genericDeriving hashable transformers
  ];
  testDepends = [ doctest filepath ];
  meta = {
    homepage = "http://github.com/analytics/hashable-extras/";
    description = "Higher-rank Hashable";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
