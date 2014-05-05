{ cabal, dataDefault, doctest, filepath, ghcPaths, haskellGenerate
, haskellSrcExts, HUnit, tasty, tastyHunit, tastyTh, time, void
}:

cabal.mkDerivation (self: {
  pname = "dynamic-cabal";
  version = "0.3.1";
  sha256 = "0jjhz6h1ggznbvi4qgv0p5x1s7j0fgv1xvkfgid57jrjvdvd4gic";
  buildDepends = [
    dataDefault filepath ghcPaths haskellGenerate haskellSrcExts time
    void
  ];
  testDepends = [ doctest filepath HUnit tasty tastyHunit tastyTh ];
  meta = {
    homepage = "http://github.com/bennofs/dynamic-cabal/";
    description = "dynamic-cabal";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
