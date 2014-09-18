# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "minioperational";
  version = "0.4.6";
  sha256 = "0ir15l9ks4wik5wmhc9v23d2wlh4v499a52pzzsl8w40406lm5ln";
  buildDepends = [ transformers ];
  meta = {
    homepage = "https://github.com/fumieval/minioperational";
    description = "fast and simple operational monad";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
