{ cabal, haskellSrc, mtl, syb }:

cabal.mkDerivation (self: {
  pname = "pointful";
  version = "1.0.2";
  sha256 = "00xlxgdajkbi5d6gv88wdpwm16xdryshszz5qklryi0p65mmp99p";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ haskellSrc mtl syb ];
  meta = {
    homepage = "http://github.com/23Skidoo/pointful";
    description = "Pointful refactoring tool";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
