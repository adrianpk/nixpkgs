# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, c2hs, dataDefault, deepseq, filepath, hspec
, hspecExpectations, libmpd, mtl, ncurses, QuickCheck, time
, transformers, utf8String, wcwidth
}:

cabal.mkDerivation (self: {
  pname = "vimus";
  version = "0.2.0";
  sha256 = "0s7hfyil9rnr9rmjb08g1l1sxybx3qdkw2f59p433fkdjp2m140h";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    dataDefault deepseq filepath libmpd mtl time utf8String wcwidth
  ];
  testDepends = [
    dataDefault hspec hspecExpectations mtl QuickCheck transformers
    wcwidth
  ];
  buildTools = [ c2hs ];
  extraLibraries = [ ncurses ];
  meta = {
    description = "An MPD client with vim-like key bindings";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ jzellner ];
  };
})
