# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, cairo, Chart, colour, dataDefaultClass, lens, mtl
, operational, time
}:

cabal.mkDerivation (self: {
  pname = "Chart-cairo";
  version = "1.3.2";
  sha256 = "19ghd5xav7pn3z5igbkbsa81vhlpvy55xscc42vbxx1v9f6shq7g";
  buildDepends = [
    cairo Chart colour dataDefaultClass lens mtl operational time
  ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/timbod7/haskell-chart/wiki";
    description = "Cairo backend for Charts";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
