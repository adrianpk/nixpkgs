{cabal, SDL, SDL_ttf} :

cabal.mkDerivation (self : {
  pname = "SDL-ttf";
  version = "0.6.1";
  sha256 = "0n6vbigkjfvvk98bp7ys14snpd1zmbz69ndhhpnrn02h363vwkal";
  propagatedBuildInputs = [ SDL SDL_ttf ];
  meta = {
    description = "Binding to libSDL_ttf";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
