{ cabal, JuicyPixels, vector }:

cabal.mkDerivation (self: {
  pname = "JuicyPixels-util";
  version = "0.1";
  sha256 = "181wryax2k43qlblink9vcg2hk8f2qxn02ifmgxa2fl95z5ar0dc";
  buildDepends = [ JuicyPixels vector ];
  meta = {
    homepage = "https://github.com/fumieval/JuicyPixels-util";
    description = "Convert JuicyPixel images into RGBA format, flip, trim and so on";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
