{ cabal, happy, syb }:

cabal.mkDerivation (self: {
  pname = "haskell-src";
  version = "1.0.1.6";
  sha256 = "1vscvbsly7k0zqb7fi6bm38dfacyl8qgmv0h25fqkn95c0v5dif7";
  buildDepends = [ syb ];
  buildTools = [ happy ];
  meta = {
    description = "Support for manipulating Haskell source code";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
