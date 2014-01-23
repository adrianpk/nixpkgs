{ cabal }:

cabal.mkDerivation (self: {
  pname = "interlude";
  version = "0.1.2";
  sha256 = "1yiv24n0mfjzbpm9p6djllhwck3brjz9adzyp6k4fpk430304k7s";
  meta = {
    homepage = "http://malde.org/~ketil/";
    description = "Replaces some Prelude functions for enhanced error reporting";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
  };
})
