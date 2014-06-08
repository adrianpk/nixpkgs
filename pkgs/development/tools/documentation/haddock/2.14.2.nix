{ cabal, Cabal, deepseq, filepath, ghcPaths, hspec, QuickCheck
, xhtml
}:

cabal.mkDerivation (self: {
  pname = "haddock";
  version = "2.14.2";
  sha256 = "0h96jj6y093h4gcqpiq0nyv7h5wjg8ji7z1im9ydivmsv0627prk";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ Cabal deepseq filepath ghcPaths xhtml ];
  testDepends = [ Cabal deepseq filepath hspec QuickCheck ];
  doCheck = false;
  meta = {
    homepage = "http://www.haskell.org/haddock/";
    description = "A documentation-generation tool for Haskell libraries";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
