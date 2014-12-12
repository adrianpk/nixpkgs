# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, contravariant, profunctors }:

cabal.mkDerivation (self: {
  pname = "product-profunctors";
  version = "0.6";
  sha256 = "1qhl2v0shzip5yh7x7b6k7xsnd4d5spf1f69h0qr0l57lm6jywl4";
  buildDepends = [ contravariant profunctors ];
  testDepends = [ profunctors ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/tomjaguarpaw/product-profunctors";
    description = "product-profunctors";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ ocharles ];
  };
})
