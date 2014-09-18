# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, numtype, time }:

cabal.mkDerivation (self: {
  pname = "dimensional";
  version = "0.13.0.1";
  sha256 = "1cn7gyskp0ax5lm5k05p6qp461hirjyhj0k1qyd64fgdmmp81vi6";
  buildDepends = [ numtype time ];
  meta = {
    homepage = "http://dimensional.googlecode.com/";
    description = "Statically checked physical dimensions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
