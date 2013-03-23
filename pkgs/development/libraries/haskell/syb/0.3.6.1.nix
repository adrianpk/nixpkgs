{ cabal }:

cabal.mkDerivation (self: {
  pname = "syb";
  version = "0.3.6.1";
  sha256 = "1xyz6ahyvairzb5n1mrmryzrxrkd4m8ywxa6r6x5nqm2xa7zqv34";
  meta = {
    homepage = "http://www.cs.uu.nl/wiki/GenericProgramming/SYB";
    description = "Scrap Your Boilerplate";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
