{ cabal, HUnit, mtl, parsec, testFramework, testFrameworkHunit }:

cabal.mkDerivation (self: {
  pname = "simple-sql-parser";
  version = "0.4.0";
  sha256 = "0mkc2x6x061qdcnaifig26jmq86rvdvp1xjmzn8g2qf0v3dw18hl";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ mtl parsec ];
  testDepends = [
    HUnit mtl parsec testFramework testFrameworkHunit
  ];
  meta = {
    homepage = "http://jakewheat.github.io/simple-sql-parser/";
    description = "A parser for SQL queries";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
