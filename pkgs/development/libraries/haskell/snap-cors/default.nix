# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, attoparsec, caseInsensitive, hashable, network, snap, text
, transformers, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "snap-cors";
  version = "1.2.5.1";
  sha256 = "1fijby8iryhcjdb7n95hdbjff4rnqyfx5s9x01nbmd9lxrch12dr";
  buildDepends = [
    attoparsec caseInsensitive hashable network snap text transformers
    unorderedContainers
  ];
  meta = {
    homepage = "http://github.com/ocharles/snap-cors";
    description = "Add CORS headers to Snap applications";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
