# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, ghcjsBase, mtl, text }:

cabal.mkDerivation (self: {
  pname = "ghcjs-dom";
  version = "0.1.1.0";
  sha256 = "0ywxkp13n78skbcr0d1m5mgz23xds27sdfxswfc9zjcsb513w3gg";
  buildDepends = [ ghcjsBase mtl text ];
  meta = {
    description = "DOM library that supports both GHCJS and WebKitGTK";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
