# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal }:

cabal.mkDerivation (self: {
  pname = "safe";
  version = "0.3.8";
  sha256 = "0k5lk85z2y8kgk7dx7km32g8vi55vnwln8ys2gs174ljd136cjdf";
  meta = {
    homepage = "http://community.haskell.org/~ndm/safe/";
    description = "Library of safe (exception free) functions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
