# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, async, blazeBuilder, deepseq, hspec, network, QuickCheck
, random, stm, text, transformers, zlib
}:

cabal.mkDerivation (self: {
  pname = "streaming-commons";
  version = "0.1.5";
  sha256 = "1gmr8yv6r87y1826rc3y3i8darwsaisqpbhjx1bn3m070g9fhqlp";
  buildDepends = [
    blazeBuilder network random stm text transformers zlib
  ];
  testDepends = [
    async blazeBuilder deepseq hspec network QuickCheck text zlib
  ];
  meta = {
    homepage = "https://github.com/fpco/streaming-commons";
    description = "Common lower-level functions needed by various streaming data libraries";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
