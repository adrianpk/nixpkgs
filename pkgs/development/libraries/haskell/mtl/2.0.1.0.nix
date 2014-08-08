# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "mtl";
  version = "2.0.1.0";
  sha256 = "1w6jpzyl08mringnd6gxwcl3y9q506r240vm1sv0aacml1hy8szk";
  buildDepends = [ transformers ];
  meta = {
    description = "Monad classes, using functional dependencies";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    hydraPlatforms = self.stdenv.lib.platforms.none;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
