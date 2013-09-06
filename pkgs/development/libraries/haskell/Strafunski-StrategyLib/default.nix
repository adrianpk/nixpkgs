{ cabal, mtl, syb }:

cabal.mkDerivation (self: {
  pname = "Strafunski-StrategyLib";
  version = "5.0.0.3";
  sha256 = "1s7410dfzkqd9j8n5g92pvh9rwglngj3ca9ipcr6xsq0n6yhs51y";
  buildDepends = [ mtl syb ];
  meta = {
    description = "Library for strategic programming";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
