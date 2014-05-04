{ cabal, HUnit, stm }:

cabal.mkDerivation (self: {
  pname = "SafeSemaphore";
  version = "0.10.1";
  sha256 = "0rpg9j6fy70i0b9dkrip9d6wim0nac0snp7qzbhykjkqlcvvgr91";
  buildDepends = [ stm ];
  testDepends = [ HUnit ];
  meta = {
    homepage = "https://github.com/ChrisKuklewicz/SafeSemaphore";
    description = "Much safer replacement for QSemN, QSem, and SampleVar";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
