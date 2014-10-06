# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, async, attoparsec, base64Bytestring, either
, monadLoops, mwcRandom, stm, text, transformers
, unorderedContainers, vector, websockets
}:

cabal.mkDerivation (self: {
  pname = "engine-io";
  version = "1.2.0";
  sha256 = "07k5zc8zbjpcj3iql0kcs4zrw5g24cngkp9yanpdmnhi18ms45dv";
  buildDepends = [
    aeson async attoparsec base64Bytestring either monadLoops mwcRandom
    stm text transformers unorderedContainers vector websockets
  ];
  meta = {
    homepage = "http://github.com/ocharles/engine.io";
    description = "A Haskell implementation of Engine.IO";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ ocharles ];
  };
})
