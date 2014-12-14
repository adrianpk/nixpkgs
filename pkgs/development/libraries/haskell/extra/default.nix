# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, filepath, QuickCheck, time }:

cabal.mkDerivation (self: {
  pname = "extra";
  version = "1.0";
  sha256 = "0ainwq8f2mp1wc30srl971xy4qnrcyrcyig1kmrxx951hgav1dkb";
  buildDepends = [ filepath time ];
  testDepends = [ filepath QuickCheck time ];
  meta = {
    homepage = "https://github.com/ndmitchell/extra#readme";
    description = "Extra functions I use";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ aycanirican ];
  };
})
