# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal }:

cabal.mkDerivation (self: {
  pname = "servant";
  version = "0.1";
  sha256 = "1bm5223rjgcm8rb3s2mclmfj2df7j059jjh572a5py0rdqzg3yj0";
  meta = {
    homepage = "http://github.com/zalora/servant";
    description = "A library to generate REST-style webservices on top of scotty, handling all the boilerplate for you";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
