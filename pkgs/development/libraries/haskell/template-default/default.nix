{ cabal, dataDefault }:

cabal.mkDerivation (self: {
  pname = "template-default";
  version = "0.1.1";
  sha256 = "07b8j11v0247fwaf3mv72m7aaq3crbsyrxmxa352vn9h2g6l1jsd";
  buildDepends = [ dataDefault ];
  meta = {
    homepage = "https://github.com/haskell-pkg-janitors/template-default";
    description = "declaring Default instances just got even easier";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
