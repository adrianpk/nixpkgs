# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, attoparsec, base16Bytestring, byteable
, caseInsensitive, conduit, cryptohash, dataDefault, failure
, hashable, HTTP, httpConduit, httpTypes, network, text, time
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "github";
  version = "0.13.1";
  sha256 = "0rz89lpswxxsdyfjb63v9md96bxr3abxzwqryh1a2jxhm7f1ia5l";
  buildDepends = [
    aeson attoparsec base16Bytestring byteable caseInsensitive conduit
    cryptohash dataDefault failure hashable HTTP httpConduit httpTypes
    network text time unorderedContainers vector
  ];
  meta = {
    homepage = "https://github.com/fpco/github";
    description = "Access to the Github API, v3";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ fuuzetsu ];
  };
})
