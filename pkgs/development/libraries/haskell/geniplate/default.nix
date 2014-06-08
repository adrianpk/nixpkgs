{ cabal, mtl }:

cabal.mkDerivation (self: {
  pname = "geniplate";
  version = "0.6.0.4";
  sha256 = "1sw1bs3nzbdmvphy5g65pl40y8wdqkgvszx1i6viqjymjq96xv20";
  buildDepends = [ mtl ];
  meta = {
    description = "Use template Haskell to generate Uniplate-like functions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
