# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, happy }:

cabal.mkDerivation (self: {
  pname = "Ebnf2ps";
  version = "1.0.12";
  sha256 = "1rd0pxj2bfx06z1p0sy8kdhyfg1y51gn1bhr71j33czls6m9ry8c";
  isLibrary = false;
  isExecutable = true;
  buildTools = [ happy ];
  meta = {
    homepage = "https://github.com/FranklinChen/Ebnf2ps";
    description = "Peter's Syntax Diagram Drawing Tool";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
