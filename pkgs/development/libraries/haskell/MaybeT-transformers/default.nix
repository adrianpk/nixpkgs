{cabal, monadsFd, transformers} :

cabal.mkDerivation (self : {
  pname = "MaybeT-transformers";
  version = "0.2";
  sha256 = "189w8dpxyq7gksca6k08hb4vpanpz06c99akgzpcpjy0i7k22ily";
  propagatedBuildInputs = [ monadsFd transformers ];
  meta = {
    description = "MaybeT monad transformer using transformers instead of mtl.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [
      self.stdenv.lib.maintainers.simons
      self.stdenv.lib.maintainers.andres
    ];
  };
})
