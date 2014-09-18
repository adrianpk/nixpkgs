# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, attoparsec, caseInsensitive, conduit, cryptohash
, dataDefault, failure, hashable, HTTP, httpConduit, httpTypes
, network, text, time, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "github";
  version = "0.11.1";
  sha256 = "0s94ivp3c40zhwwfxa6nzzgwh2frfih8as81i0kidx4ca35wf92k";
  buildDepends = [
    aeson attoparsec caseInsensitive conduit cryptohash dataDefault
    failure hashable HTTP httpConduit httpTypes network text time
    unorderedContainers vector
  ];
  meta = {
    homepage = "https://github.com/fpco/github";
    description = "Access to the Github API, v3";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ fuuzetsu ];
  };
})
