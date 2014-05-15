{ cabal }:

cabal.mkDerivation (self: {
  pname = "cond";
  version = "0.4.1";
  sha256 = "16xk8clsxv5qi5f745xvs44y8p8dnmlmjkjzwqz9jl8fbmkmki3b";
  meta = {
    homepage = "https://github.com/kallisti-dev/cond";
    description = "Basic conditional and boolean operators with monadic variants";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
