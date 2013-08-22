{ cabal, Cabal, filepath }:

cabal.mkDerivation (self: {
  pname = "cabal-ghci";
  version = "0.3";
  sha256 = "1x7fpvvmr2mq7l960wgsijhyrdaiq3lnnl3z6drklc5p73pms8w6";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ Cabal filepath ];
  meta = {
    homepage = "http://github.com/atnnn/cabal-ghci";
    description = "Set up ghci with options taken from a .cabal file";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
