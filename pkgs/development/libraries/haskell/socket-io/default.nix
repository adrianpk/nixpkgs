# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, attoparsec, engineIo, mtl, stm, text, transformers
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "socket-io";
  version = "1.0.1";
  sha256 = "0257c5wf6b9rmprqq5q5d7fih4s2szwv98w16ggl61p8khf5d2qs";
  buildDepends = [
    aeson attoparsec engineIo mtl stm text transformers
    unorderedContainers vector
  ];
  meta = {
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ ocharles ];
  };
})
