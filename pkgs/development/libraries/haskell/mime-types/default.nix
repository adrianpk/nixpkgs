{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "mime-types";
  version = "0.1.0.4";
  sha256 = "0bxhkwz8p7mhg5kspbpc5zm4k50pc0r5pzjr6807y88x8vjpvj2x";
  buildDepends = [ text ];
  meta = {
    homepage = "https://github.com/yesodweb/wai";
    description = "Basic mime-type handling types and functions";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
