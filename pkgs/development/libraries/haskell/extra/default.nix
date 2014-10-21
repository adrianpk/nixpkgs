# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, filepath, QuickCheck, time }:

cabal.mkDerivation (self: {
  pname = "extra";
  version = "0.3.1";
  sha256 = "06ndd2frbpi1xnjgg82m25m7n8b5ass1am9pi5k8hik02d9paf28";
  buildDepends = [ filepath time ];
  testDepends = [ QuickCheck time ];
  meta = {
    homepage = "https://github.com/ndmitchell/extra#readme";
    description = "Extra functions I use";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ aycanirican ];
  };
})
