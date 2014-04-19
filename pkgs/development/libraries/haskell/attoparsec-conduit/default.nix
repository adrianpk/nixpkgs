{ cabal, conduit }:

cabal.mkDerivation (self: {
  pname = "attoparsec-conduit";
  version = "1.1.0";
  sha256 = "18xn3nzxfghcd88cana1jw85ijv0ysw3bp36fb6r5wsf6m79z01y";
  buildDepends = [ conduit ];
  noHaddock = true;
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Consume attoparsec parsers via conduit. (deprecated)";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
