# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, blazeSvg, Chart, colour, dataDefaultClass, diagramsCore
, diagramsLib, diagramsPostscript, diagramsSvg, lens, mtl
, operational, SVGFonts, text, time
}:

cabal.mkDerivation (self: {
  pname = "Chart-diagrams";
  version = "1.3";
  sha256 = "1lfdv2bn942w4b0bjd6aw59wdc2jfk305ym5vm88liy9127b65bp";
  buildDepends = [
    blazeSvg Chart colour dataDefaultClass diagramsCore diagramsLib
    diagramsPostscript diagramsSvg lens mtl operational SVGFonts text
    time
  ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/timbod7/haskell-chart/wiki";
    description = "Diagrams backend for Charts";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
