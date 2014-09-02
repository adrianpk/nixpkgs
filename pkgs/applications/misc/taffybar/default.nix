# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, cairo, dbus, dyre, enclosedExceptions, filepath, gtk
, gtkTraymanager, HStringTemplate, HTTP, mtl, network, parsec, safe
, split, stm, text, time, transformers, utf8String, X11, xdgBasedir
, xmonad, xmonadContrib
}:

cabal.mkDerivation (self: {
  pname = "taffybar";
  version = "0.4.1";
  sha256 = "0b4x78sq5x1w0xnc5fk4ixpbkl8cwjfyb4fq8vy21shf4n0fri26";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    cairo dbus dyre enclosedExceptions filepath gtk gtkTraymanager
    HStringTemplate HTTP mtl network parsec safe split stm text time
    transformers utf8String X11 xdgBasedir xmonad xmonadContrib
  ];
  pkgconfigDepends = [ gtk ];
  meta = {
    homepage = "http://github.com/travitch/taffybar";
    description = "A desktop bar similar to xmobar, but with more GUI";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
