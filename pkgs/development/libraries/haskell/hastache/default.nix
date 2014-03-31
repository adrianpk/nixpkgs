{ cabal, blazeBuilder, filepath, HUnit, ieee754, mtl, syb, text
, transformers, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hastache";
  version = "0.6.0";
  sha256 = "1z609mhsc875ba3k6mlmlqpmqlwgxpav2asnf83yzq1q7bfs0cxh";
  buildDepends = [
    blazeBuilder filepath ieee754 mtl syb text transformers utf8String
  ];
  testDepends = [ HUnit mtl syb text ];
  meta = {
    homepage = "http://github.com/lymar/hastache";
    description = "Haskell implementation of Mustache templates";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
