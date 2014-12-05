# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, alex, filepath, happy, hashtables, random }:

cabal.mkDerivation (self: {
  pname = "gtk2hs-buildtools";
  version = "0.13.0.3";
  sha256 = "1ijcmcjp8mralpzl1gvh24bzq8njlzkvck1r07b010rrklv04arp";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ filepath hashtables random ];
  buildTools = [ alex happy ];
  meta = {
    homepage = "http://projects.haskell.org/gtk2hs/";
    description = "Tools to build the Gtk2Hs suite of User Interface libraries";
    license = self.stdenv.lib.licenses.gpl2;
    platforms = self.ghc.meta.platforms;
  };
})
