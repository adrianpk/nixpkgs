{ cabal, async, attoparsec, base64Bytestring, blazeBuilder
, byteable, conduit, conduitExtra, cryptohash, cryptohashConduit
, cssText, dataDefault, fileEmbed, filepath, hashable, hjsmin
, hspec, httpTypes, HUnit, mimeTypes, resourcet, shakespeareCss
, systemFileio, systemFilepath, text, transformers, unixCompat
, unorderedContainers, wai, waiAppStatic, waiExtra, waiTest
, yesodCore, yesodTest
}:

cabal.mkDerivation (self: {
  pname = "yesod-static";
  version = "1.2.4";
  sha256 = "0r5bz1jmgjd7cmvhkp3ahgl610bssvgxxsvb626dvqz2vqc0061z";
  buildDepends = [
    async attoparsec base64Bytestring blazeBuilder byteable conduit
    conduitExtra cryptohash cryptohashConduit cssText dataDefault
    fileEmbed filepath hashable hjsmin httpTypes mimeTypes resourcet
    shakespeareCss systemFileio systemFilepath text transformers
    unixCompat unorderedContainers wai waiAppStatic yesodCore
  ];
  testDepends = [
    async base64Bytestring byteable conduit conduitExtra cryptohash
    cryptohashConduit dataDefault fileEmbed filepath hjsmin hspec
    httpTypes HUnit mimeTypes resourcet shakespeareCss systemFileio
    systemFilepath text transformers unixCompat unorderedContainers wai
    waiAppStatic waiExtra waiTest yesodCore yesodTest
  ];
  doCheck = false;
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Static file serving subsite for Yesod Web Framework";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
