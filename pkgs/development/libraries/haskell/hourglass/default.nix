# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, deepseq, mtl, tasty, tastyHunit, tastyQuickcheck, time }:

cabal.mkDerivation (self: {
  pname = "hourglass";
  version = "0.2.5";
  sha256 = "08nw9zqa0y09lw0c6qlh9pn8vr6h03mw1i7n7w0y3fv94az9vg9v";
  buildDepends = [ deepseq ];
  testDepends = [
    deepseq mtl tasty tastyHunit tastyQuickcheck time
  ];
  meta = {
    homepage = "https://github.com/vincenthz/hs-hourglass";
    description = "simple performant time related library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
