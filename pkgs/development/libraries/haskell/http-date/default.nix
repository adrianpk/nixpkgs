{ cabal, attoparsec, doctest, hspec, time }:

cabal.mkDerivation (self: {
  pname = "http-date";
  version = "0.0.4";
  sha256 = "1pbm066i1cpa3z2kfsqpva0qixnx87s76dpafz3wf6dkaqj8n8i5";
  buildDepends = [ attoparsec ];
  testDepends = [ doctest hspec time ];
  meta = {
    description = "HTTP Date parser/formatter";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
