# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, hspec }:

cabal.mkDerivation (self: {
  pname = "word8";
  version = "0.1.1";
  sha256 = "1xpa0haacimrblxg3x3n5vdcnkg3ff5zqamppdarv0zvkcdj139r";
  testDepends = [ hspec ];
  meta = {
    description = "Word8 library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
