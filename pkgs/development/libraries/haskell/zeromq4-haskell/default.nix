{ cabal, async, exceptions, QuickCheck, semigroups, tasty
, tastyHunit, tastyQuickcheck, transformers, zeromq
}:

cabal.mkDerivation (self: {
  pname = "zeromq4-haskell";
  version = "0.6";
  sha256 = "1n8vvlwnmvi2hlqhkmzsqgpbpxnhdcs8jy3rj1srsg729m2aqc8y";
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
