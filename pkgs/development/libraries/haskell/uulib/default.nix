{ cabal }:

cabal.mkDerivation (self: {
  pname = "uulib";
  version = "0.9.16";
  sha256 = "06d9i712flxj62j7rdxvy9b0ximhdfvdakwpmr886l6fi3xpajl3";
  meta = {
    homepage = "http://www.cs.uu.nl/wiki/HUT/WebHome";
    description = "Haskell Utrecht Tools Library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
