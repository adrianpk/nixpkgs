{ cabal, haskellSrcExts, mtl, uuagcBootstrap, uuagcCabal, uulib }:

cabal.mkDerivation (self: {
  pname = "uuagc";
  version = "0.9.39.0";
  sha256 = "1jx1cisch97dd2dy2ddlx7s8zxrrv1wwp9pm2bl59sjakpp1kqwh";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    haskellSrcExts mtl uuagcBootstrap uuagcCabal uulib
  ];
  meta = {
    homepage = "http://www.cs.uu.nl/wiki/HUT/WebHome";
    description = "Attribute Grammar System of Universiteit Utrecht";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
