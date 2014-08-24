# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, cairo, colour, dataDefaultClass, diagramsCore, diagramsLib
, filepath, hashable, JuicyPixels, lens, mtl, optparseApplicative
, pango, split, statestack, time, transformers, vector
}:

cabal.mkDerivation (self: {
  pname = "diagrams-cairo";
  version = "1.2.0.1";
  sha256 = "0y7llxxs34i814nc3c79ykv75znplzqq7njvq7a5fyxl81ji0z4c";
  buildDepends = [
    cairo colour dataDefaultClass diagramsCore diagramsLib filepath
    hashable JuicyPixels lens mtl optparseApplicative pango split
    statestack time transformers vector
  ];
  meta = {
    homepage = "http://projects.haskell.org/diagrams";
    description = "Cairo backend for diagrams drawing EDSL";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ bergey ];
  };
})
