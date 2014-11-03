# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, blazeHtml, blazeMarkup, conduitExtra, dataDefault
, fastLogger, monadControl, monadLogger, safe, shakespeare
, streamingCommons, text, transformers, unorderedContainers, wai
, waiExtra, warp, yaml, yesodAuth, yesodCore, yesodForm
, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod";
  version = "1.4.0";
  sha256 = "1h4jrzbf85malv3k1r4xxqp2y537naj1l284wazsrs2xikndwwn9";
  buildDepends = [
    aeson blazeHtml blazeMarkup conduitExtra dataDefault fastLogger
    monadControl monadLogger safe shakespeare streamingCommons text
    transformers unorderedContainers wai waiExtra warp yaml yesodAuth
    yesodCore yesodForm yesodPersistent
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Creation of type-safe, RESTful web applications";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
