{ cabal, hspec, silently }:

cabal.mkDerivation (self: {
  pname = "nanospec";
  version = "0.2.0";
  sha256 = "0g10l86cv33r58zxn2bprqlm80i7g86bwzhn9jqg9s81xc0aw2qv";
  testDepends = [ hspec silently ];
  doCheck = false;
  meta = {
    description = "A lightweight implementation of a subset of Hspec's API";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
