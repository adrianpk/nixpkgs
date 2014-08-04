# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, ansiTerminal, base64Bytestring, blazeBuilder
, caseInsensitive, dataDefault, dataDefaultClass, deepseq
, fastLogger, hspec, httpTypes, HUnit, liftedBase, network
, resourcet, streamingCommons, stringsearch, text, time
, transformers, void, wai, waiLogger, word8, zlib
}:

cabal.mkDerivation (self: {
  pname = "wai-extra";
  version = "3.0.1.2";
  sha256 = "15v3mk7kbinvynsfxb95lwvg52wkpm3q9k5an8ak936ll3j2s14z";
  buildDepends = [
    ansiTerminal base64Bytestring blazeBuilder caseInsensitive
    dataDefaultClass deepseq fastLogger httpTypes liftedBase network
    resourcet streamingCommons stringsearch text time transformers void
    wai waiLogger word8
  ];
  testDepends = [
    blazeBuilder dataDefault fastLogger hspec httpTypes HUnit resourcet
    text transformers wai zlib
  ];
  jailbreak = true;
  meta = {
    homepage = "http://github.com/yesodweb/wai";
    description = "Provides some basic WAI handlers and middleware";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
