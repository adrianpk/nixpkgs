# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal }:

cabal.mkDerivation (self: {
  pname = "srcloc";
  version = "0.4.0";
  sha256 = "00af562n4m3nwlhl86x8rx7hhpnhwaijin61wk574pp47bh2jg0k";
  meta = {
    homepage = "http://www.eecs.harvard.edu/~mainland/";
    description = "Data types for managing source code locations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
