# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, primitive }:

cabal.mkDerivation (self: {
  pname = "atomic-primops";
  version = "0.6.1";
  sha256 = "1j8slmqsyhvx7xns1qpvbmcjsfqfkphycv32hgcmk17wl1fzbyi7";
  buildDepends = [ primitive ];
  meta = {
    homepage = "https://github.com/rrnewton/haskell-lockfree/wiki";
    description = "A safe approach to CAS and other atomic ops in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
