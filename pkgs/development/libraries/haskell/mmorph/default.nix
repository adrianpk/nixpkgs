# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "mmorph";
  version = "1.0.4";
  sha256 = "0k5zlzmnixfwcjrqvhgi3i6xg532b0gsjvc39v5jigw69idndqr2";
  buildDepends = [ transformers ];
  meta = {
    description = "Monad morphisms";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
