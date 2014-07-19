# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, mtl, random }:

cabal.mkDerivation (self: {
  pname = "arithmoi";
  version = "0.4.1.1";
  sha256 = "02wrm24dpcsdsjaic30416axad5s4y822si1am4smb2qvrhps9ix";
  buildDepends = [ mtl random ];
  configureFlags = "-f-llvm";
  jailbreak = true;
  meta = {
    homepage = "https://bitbucket.org/dafis/arithmoi";
    description = "Efficient basic number-theoretic functions. Primes, powers, integer logarithms.";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
