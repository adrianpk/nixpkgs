{ cabal, stm, wxcore }:

cabal.mkDerivation (self: {
  pname = "wx";
  version = "0.90.1.0";
  sha256 = "1669mrd73c3v7c4yc0zgyqsnfgzb7561v1wd168y06d0db1nlkn9";
  buildDepends = [ stm wxcore ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/WxHaskell";
    description = "wxHaskell";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
