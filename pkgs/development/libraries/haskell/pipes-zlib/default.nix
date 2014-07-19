# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, pipes, transformers, zlib, zlibBindings }:

cabal.mkDerivation (self: {
  pname = "pipes-zlib";
  version = "0.4.0.1";
  sha256 = "1k91q5hci4hk2kzaqfvg1nwbklqyg83wwhm3sdfhdn2famj0mls0";
  buildDepends = [ pipes transformers zlib zlibBindings ];
  meta = {
    homepage = "https://github.com/k0001/pipes-zlib";
    description = "Zlib compression and decompression for Pipes streams";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
