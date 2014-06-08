{ cabal, aeson, blazeBuilder, conduit, monadControl, persistent
, postgresqlLibpq, postgresqlSimple, resourcet, text, time
, transformers
}:

cabal.mkDerivation (self: {
  pname = "persistent-postgresql";
  version = "1.3.1.1";
  sha256 = "1qi19fm7waxrbh795jvcny7aaj6b64jqcwv772xjzl9dbv3q9qhc";
  buildDepends = [
    aeson blazeBuilder conduit monadControl persistent postgresqlLibpq
    postgresqlSimple resourcet text time transformers
  ];
  jailbreak = true;
  meta = {
    homepage = "http://www.yesodweb.com/book/persistent";
    description = "Backend for the persistent library using postgresql";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
