# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal }:

cabal.mkDerivation (self: {
  pname = "statvfs";
  version = "0.2";
  sha256 = "16z9fddgvf5sl7zy7p74fng9lkdw5m9i5np3q4s2h8jdi43mwmg1";
  meta = {
    description = "Get unix filesystem statistics with statfs, statvfs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
