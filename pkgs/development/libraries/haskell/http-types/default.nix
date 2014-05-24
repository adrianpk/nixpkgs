{ cabal, blazeBuilder, caseInsensitive, doctest, hspec, QuickCheck
, quickcheckInstances, text
}:

cabal.mkDerivation (self: {
  pname = "http-types";
  version = "0.8.5";
  sha256 = "0d282sf3xyk5makhnwfm2k9mgw1fkh07kasmy85fiwjkc1447ciw";
  buildDepends = [ blazeBuilder caseInsensitive text ];
  testDepends = [
    blazeBuilder doctest hspec QuickCheck quickcheckInstances text
  ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/aristidb/http-types";
    description = "Generic HTTP types for Haskell (for both client and server code)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
