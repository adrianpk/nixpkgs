{cabal, ansiTerminal, split, text} :

cabal.mkDerivation (self : {
  pname = "mpppc";
  version = "0.1.2";
  sha256 = "1zms71wx5a6rd60xy1pv6g1kxlx0hzh36pbr5a5lkfflc583z1k5";
  propagatedBuildInputs = [ ansiTerminal split text ];
  meta = {
    description = "Multi-dimensional parametric pretty-printer with color";
    license = "GPL";
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
