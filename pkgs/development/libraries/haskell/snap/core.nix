{ cabal, attoparsec, attoparsecEnumerator, blazeBuilder
, blazeBuilderEnumerator, bytestringMmap, caseInsensitive, deepseq
, enumerator, filepath, hashable, HUnit, MonadCatchIOTransformers
, mtl, random, regexPosix, text, time, unixCompat
, unorderedContainers, vector, zlibEnum
}:

cabal.mkDerivation (self: {
  pname = "snap-core";
  version = "0.9.6.3";
  sha256 = "0i3gl1kxzi2l76sqhyhda7lrcvq8hq6aqgwvfx5k9fa2xic01dw1";
  buildDepends = [
    attoparsec attoparsecEnumerator blazeBuilder blazeBuilderEnumerator
    bytestringMmap caseInsensitive deepseq enumerator filepath hashable
    HUnit MonadCatchIOTransformers mtl random regexPosix text time
    unixCompat unorderedContainers vector zlibEnum
  ];
  meta = {
    homepage = "http://snapframework.com/";
    description = "Snap: A Haskell Web Framework (core interfaces and types)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
