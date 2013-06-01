{ cabal, yesodCore }:

cabal.mkDerivation (self: {
  pname = "yesod-json";
  version = "1.2.0";
  sha256 = "0d035k1ls5iq1c12yxknyc33qd22ayyhl69y62zmcw7arwx35sgw";
  buildDepends = [ yesodCore ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Generate content for Yesod using the aeson package. (deprecated)";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
