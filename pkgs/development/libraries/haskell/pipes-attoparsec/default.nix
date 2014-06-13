{ cabal, attoparsec, HUnit, mmorph, pipes, pipesParse, tasty
, tastyHunit, text, transformers
}:

cabal.mkDerivation (self: {
  pname = "pipes-attoparsec";
  version = "0.5.1";
  sha256 = "0qvsvbcn211xp4c669cpljmnsqn9zk1rn94ya1dbq77l970s8xah";
  buildDepends = [ attoparsec pipes pipesParse text transformers ];
  testDepends = [
    attoparsec HUnit mmorph pipes pipesParse tasty tastyHunit text
    transformers
  ];
  meta = {
    homepage = "https://github.com/k0001/pipes-attoparsec";
    description = "Attoparsec and Pipes integration";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
