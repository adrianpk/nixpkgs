# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, async, exceptions, QuickCheck, semigroups, tasty
, tastyHunit, tastyQuickcheck, transformers, zeromq
}:

cabal.mkDerivation (self: {
  pname = "zeromq4-haskell";
  version = "0.6.2";
  sha256 = "07dbsapzc4hqq9sg63v4wyjad13sqh9zsx3ckwc5hg5z6vknpafb";
  buildDepends = [ async exceptions semigroups transformers ];
  testDepends = [
    async QuickCheck tasty tastyHunit tastyQuickcheck
  ];
  pkgconfigDepends = [ zeromq ];
  meta = {
    homepage = "http://github.com/twittner/zeromq-haskell/";
    description = "Bindings to ZeroMQ 4.x";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
