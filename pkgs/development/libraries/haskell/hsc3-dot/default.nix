# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, filepath, hsc3 }:

cabal.mkDerivation (self: {
  pname = "hsc3-dot";
  version = "0.15";
  sha256 = "1ck2g15zw23smry1xvn9ida8ln57vnvkxvr3khhp5didwisgm90m";
  buildDepends = [ filepath hsc3 ];
  meta = {
    homepage = "http://rd.slavepianos.org/t/hsc3-dot";
    description = "haskell supercollider graph drawing";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
  };
})
