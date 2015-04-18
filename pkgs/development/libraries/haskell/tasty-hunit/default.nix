# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, tasty }:

cabal.mkDerivation (self: {
  pname = "tasty-hunit";
  version = "0.9.0.1";
  sha256 = "0rhdjb4fakcbkz4cvmmf679zad9h5yr31i1g9xm1338p6xd4vwcb";
  buildDepends = [ tasty ];
  meta = {
    homepage = "http://documentup.com/feuerbach/tasty";
    description = "HUnit support for the Tasty test framework";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ ocharles ];
  };
})
