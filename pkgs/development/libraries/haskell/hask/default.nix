# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, constraints, reflection, tagged, transformers, void }:

cabal.mkDerivation (self: {
  pname = "hask";
  version = "0";
  sha256 = "1c87jxafxpnlyblhdif4br61wqvnad0s6hvfhmzhx9y1jri3rb39";
  buildDepends = [ constraints reflection tagged transformers void ];
  meta = {
    homepage = "http://github.com/ekmett/hask";
    description = "Categories";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
