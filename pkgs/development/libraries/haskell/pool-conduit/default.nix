{ cabal, monadControl, resourcePool, resourcet, transformers }:

cabal.mkDerivation (self: {
  pname = "pool-conduit";
  version = "0.1.2.3";
  sha256 = "1myjbmbh0jm89ycx9d961mpgw8hp7al8wgnsls4p19gvr73gcbfv";
  buildDepends = [
    monadControl resourcePool resourcet transformers
  ];
  meta = {
    homepage = "http://www.yesodweb.com/book/persistent";
    description = "Resource pool allocations via ResourceT. (deprecated)";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
