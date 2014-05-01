{ cabal, haskellSrcExts }:

cabal.mkDerivation (self: {
  pname = "groom";
  version = "0.1.2";
  sha256 = "045hzpnf17rp1ib6q3gcznl9b7ivz5zmv0gh7qfg726kr8i030hf";
  buildDepends = [ haskellSrcExts ];
  meta = {
    description = "Pretty printing for well-behaved Show instances";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
  };
})
