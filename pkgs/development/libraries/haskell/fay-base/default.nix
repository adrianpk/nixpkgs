# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, fay }:

cabal.mkDerivation (self: {
  pname = "fay-base";
  version = "0.19.2";
  sha256 = "08iv3097h877hxbmpmar1p526famm5pb1djq3qwla3bkqrzxgmf4";
  buildDepends = [ fay ];
  meta = {
    homepage = "https://github.com/faylang/fay-base";
    description = "The base package for Fay";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ ocharles ];
  };
})
