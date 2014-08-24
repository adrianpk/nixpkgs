# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, attoparsec, authenticateOauth, caseInsensitive
, conduit, conduitExtra, dataDefault, doctest, filepath, hlint
, hspec, httpClient, httpConduit, httpTypes, lens, lensAeson
, monadControl, monadLogger, networkUri, resourcet, text, time
, transformers, transformersBase, twitterTypes
}:

cabal.mkDerivation (self: {
  pname = "twitter-conduit";
  version = "0.0.5.6";
  sha256 = "1l6gk4538nqknrj082hkdy2jp4gzyq3y473p8gg4mm2n67417r9m";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson attoparsec authenticateOauth conduit conduitExtra dataDefault
    httpClient httpConduit httpTypes lens lensAeson monadLogger
    networkUri resourcet text time transformers twitterTypes
  ];
  testDepends = [
    aeson attoparsec authenticateOauth caseInsensitive conduit
    conduitExtra dataDefault doctest filepath hlint hspec httpClient
    httpConduit httpTypes lens lensAeson monadControl monadLogger
    networkUri resourcet text time transformers transformersBase
    twitterTypes
  ];
  meta = {
    homepage = "https://github.com/himura/twitter-conduit";
    description = "Twitter API package with conduit interface and Streaming API support";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ ocharles ];
    hydraPlatforms = self.stdenv.lib.platforms.none;
    broken = true;
  };
})
