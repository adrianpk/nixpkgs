# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, QuickCheck, time }:

cabal.mkDerivation (self: {
  pname = "pathtype";
  version = "0.5.4";
  sha256 = "1ns5q3nrkl99xp4mrmk8wpvb9qzyvnw5cyjwh5rh76ykm2d5dbg7";
  buildDepends = [ QuickCheck time ];
  meta = {
    homepage = "http://code.haskell.org/pathtype";
    description = "Type-safe replacement for System.FilePath etc";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
