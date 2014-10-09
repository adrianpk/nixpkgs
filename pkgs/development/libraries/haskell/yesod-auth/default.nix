# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, attoparsecConduit, authenticate, base16Bytestring
, base64Bytestring, binary, blazeBuilder, blazeHtml, blazeMarkup
, byteable, conduit, conduitExtra, cryptohash, dataDefault
, emailValidate, fileEmbed, hamlet, httpClient, httpConduit
, httpTypes, liftedBase, mimeMail, networkUri, persistent
, persistentTemplate, random, resourcet, safe, shakespeare
, shakespeareCss, shakespeareJs, text, time, transformers
, unorderedContainers, wai, yesodCore, yesodForm, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod-auth";
  version = "1.3.4.6";
  sha256 = "17lp99pinq72if527ml4sfqvvjn7kmkcc5jq1l9vsbfgqckmqcff";
  buildDepends = [
    aeson attoparsecConduit authenticate base16Bytestring
    base64Bytestring binary blazeBuilder blazeHtml blazeMarkup byteable
    conduit conduitExtra cryptohash dataDefault emailValidate fileEmbed
    hamlet httpClient httpConduit httpTypes liftedBase mimeMail
    networkUri persistent persistentTemplate random resourcet safe
    shakespeare shakespeareCss shakespeareJs text time transformers
    unorderedContainers wai yesodCore yesodForm yesodPersistent
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Authentication for Yesod";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
