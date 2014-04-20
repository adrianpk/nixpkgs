{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "mime";
  version = "0.4.0.1";
  sha256 = "1m987sqnns54qbsg68332mnrjkh71z6s83cma2kwavf0y305mrp0";
  buildDepends = [ text ];
  meta = {
    homepage = "https://github.com/GaloisInc/mime";
    description = "Working with MIME types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
