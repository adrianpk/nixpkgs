# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, binary, blazeHtml, blazeMarkup, cmdargs, cryptohash
, dataDefault, deepseq, filepath, fsnotify, httpConduit, httpTypes
, HUnit, lrucache, mtl, network, networkUri, pandoc, pandocCiteproc
, parsec, QuickCheck, random, regexBase, regexTdfa, snapCore
, snapServer, systemFilepath, tagsoup, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, text, time
, utillinux
}:

cabal.mkDerivation (self: {
  pname = "hakyll";
  version = "4.6.1.0";
  sha256 = "19yw5yp84vli228zmyz23vs6d5mb14rjbb81kvyra8fi8mmy2l6b";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary blazeHtml blazeMarkup cmdargs cryptohash dataDefault deepseq
    filepath fsnotify httpConduit httpTypes lrucache mtl network
    networkUri pandoc pandocCiteproc parsec random regexBase regexTdfa
    snapCore snapServer systemFilepath tagsoup text time
  ];
  testDepends = [
    binary blazeHtml blazeMarkup cmdargs cryptohash dataDefault deepseq
    filepath fsnotify httpConduit httpTypes HUnit lrucache mtl network
    networkUri pandoc pandocCiteproc parsec QuickCheck random regexBase
    regexTdfa snapCore snapServer systemFilepath tagsoup testFramework
    testFrameworkHunit testFrameworkQuickcheck2 text time utillinux
  ];
  jailbreak = true;
  meta = {
    homepage = "http://jaspervdj.be/hakyll";
    description = "A static website compiler library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ fuuzetsu ];
  };
})
