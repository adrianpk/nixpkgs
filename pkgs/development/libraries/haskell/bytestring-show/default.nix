# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, binary }:

cabal.mkDerivation (self: {
  pname = "bytestring-show";
  version = "0.3.5.6";
  sha256 = "04h81a0bh2fvnkby1qafnydb29gzk6d4d311i2lbn7lm2vyjw919";
  buildDepends = [ binary ];
  meta = {
    homepage = "http://code.haskell.org/~dolio/";
    description = "Efficient conversion of values into readable byte strings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
