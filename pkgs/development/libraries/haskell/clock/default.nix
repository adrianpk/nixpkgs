# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal }:

cabal.mkDerivation (self: {
  pname = "clock";
  version = "0.4.1.1";
  sha256 = "0xbhx16sa0rwidaljp8lklb5ifhdc8cccbyznrpxqqwh8icm5pjp";
  meta = {
    homepage = "http://corsis.github.com/clock/";
    description = "High-resolution clock functions: monotonic, realtime, cputime";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
