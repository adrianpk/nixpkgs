# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, attoparsec, deepseq, either, exceptions, hspec
, httpClient, httpTypes, network, networkUri, QuickCheck, safe
, servant, servantServer, stringConversions, text, transformers
, wai, warp
}:

cabal.mkDerivation (self: {
  pname = "servant-client";
  version = "0.2.1";
  sha256 = "1mwmca96sld3s6n4hxq3zl9pjw24halwa061awjb23kc49cmp4pn";
  buildDepends = [
    aeson attoparsec either exceptions httpClient httpTypes networkUri
    safe servant stringConversions text transformers
  ];
  testDepends = [
    aeson deepseq either hspec httpTypes network QuickCheck servant
    servantServer wai warp
  ];
  meta = {
    homepage = "http://haskell-servant.github.io/";
    description = "automatical derivation of querying functions for servant webservices";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
