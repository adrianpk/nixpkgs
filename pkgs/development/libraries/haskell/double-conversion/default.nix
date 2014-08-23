# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, testFramework, testFrameworkQuickcheck2, text }:

cabal.mkDerivation (self: {
  pname = "double-conversion";
  version = "2.0.1.0";
  sha256 = "034ji9jgf3jl0n5pp1nki3lsg173c3b9vniwnwp1q21iasqbawh0";
  buildDepends = [ text ];
  testDepends = [ testFramework testFrameworkQuickcheck2 text ];
  meta = {
    homepage = "https://github.com/bos/double-conversion";
    description = "Fast conversion between double precision floating point and text";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
