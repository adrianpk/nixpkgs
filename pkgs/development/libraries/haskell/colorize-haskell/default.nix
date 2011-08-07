{cabal, ansiTerminal, haskellLexer} :

cabal.mkDerivation (self : {
  pname = "colorize-haskell";
  version = "1.0.1";
  sha256 = "1v4spa6vw9igjpd1dr595z5raz5fr8f485q5w9imrv8spms46xh3";
  propagatedBuildInputs = [ ansiTerminal haskellLexer ];
  meta = {
    homepage = "http://github.com/yav/colorize-haskell";
    description = "Highligt Haskell source";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
