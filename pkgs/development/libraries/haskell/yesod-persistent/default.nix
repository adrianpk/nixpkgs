{ cabal, blazeBuilder, conduit, hspec, persistent, persistentSqlite
, persistentTemplate, resourcePool, resourcet, text, transformers
, waiExtra, waiTest, yesodCore
}:

cabal.mkDerivation (self: {
  pname = "yesod-persistent";
  version = "1.2.3";
  sha256 = "1kdspz6y32r8kl0qk89hgwi4n6dnxch7wriv829cnwqm0bzjfdpw";
  buildDepends = [
    blazeBuilder conduit persistent persistentTemplate resourcePool
    resourcet transformers yesodCore
  ];
  testDepends = [
    blazeBuilder conduit hspec persistent persistentSqlite text
    waiExtra waiTest yesodCore
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Some helpers for using Persistent from Yesod";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
