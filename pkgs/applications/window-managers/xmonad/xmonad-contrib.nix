{ cabal, extensibleExceptions, mtl, random, utf8String, X11, X11Xft
, xmonad
}:

cabal.mkDerivation (self: {
  pname = "xmonad-contrib";
  version = "0.11.3";
  sha256 = "14h9vr33yljymswj50wbimav263y9abdcgi07mvfis0zd08rxqxa";
  buildDepends = [
    extensibleExceptions mtl random utf8String X11 X11Xft xmonad
  ];
  meta = {
    homepage = "http://xmonad.org/";
    description = "Third party extensions for xmonad";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
