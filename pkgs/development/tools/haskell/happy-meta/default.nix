# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, haskellSrcMeta, mtl }:

cabal.mkDerivation (self: {
  pname = "happy-meta";
  version = "0.2.0.6";
  sha256 = "1q6sd5zaxzx85z3zcy99b6qrf8fj93ryy33y1g6rdzfw07dwf4lh";
  buildDepends = [ haskellSrcMeta mtl ];
  meta = {
    description = "Quasi-quoter for Happy parsers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
