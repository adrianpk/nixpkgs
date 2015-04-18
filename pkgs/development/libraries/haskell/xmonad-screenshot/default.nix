# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, gtk, xmonad }:

cabal.mkDerivation (self: {
  pname = "xmonad-screenshot";
  version = "0.1.1.0";
  sha256 = "1iy6c8dis5jkgamkbbgxvbajz8f03bwhwdwk46l6wvlgmb072wl4";
  buildDepends = [ gtk xmonad ];
  meta = {
    homepage = "http://github.com/supki/xmonad-screenshot";
    description = "Workspaces screenshooting utility for XMonad";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
