# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, attoparsec, caseInsensitive, conduit, dataDefault
, failure, hashable, HTTP, httpConduit, httpTypes, network, text
, time, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "github";
  version = "0.10.0";
  sha256 = "1llwzkhyw5wazczpiv3w8dq4l7j3q49ii64yh7cxwakkp2h5yiwb";
  buildDepends = [
    aeson attoparsec caseInsensitive conduit dataDefault failure
    hashable HTTP httpConduit httpTypes network text time
    unorderedContainers vector
  ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/fpco/github";
    description = "Access to the Github API, v3";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
