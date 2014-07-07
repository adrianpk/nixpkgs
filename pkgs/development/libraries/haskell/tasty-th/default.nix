{ cabal, languageHaskellExtract, tasty }:

cabal.mkDerivation (self: {
  pname = "tasty-th";
  version = "0.1.2";
  sha256 = "1x3kixv0hnb7icigz2kfq959pivdc4jaaalvdgn8dlyqzkvfjzx4";
  buildDepends = [ languageHaskellExtract tasty ];
  meta = {
    homepage = "http://github.com/bennofs/tasty-th";
    description = "Automagically generate the HUnit- and Quickcheck-bulk-code using Template Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
