# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, async, hinotify, systemFileio, systemFilepath, tasty
, tastyHunit, temporaryRc, text, time
}:

cabal.mkDerivation (self: {
  pname = "fsnotify";
  version = "0.1.0.3";
  sha256 = "0m6jyg45azk377jklgwyqrx95q174cxd5znpyh9azznkh09wq58z";
  buildDepends = [
    async hinotify systemFileio systemFilepath text time
  ];
  testDepends = [
    async systemFileio systemFilepath tasty tastyHunit temporaryRc
  ];
  meta = {
    description = "Cross platform library for file change notification";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
