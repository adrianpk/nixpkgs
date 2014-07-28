# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, ansiTerminal, cmdargs, dlist, filepath, regexPosix, safe
, split, stm, stringsearch, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "cgrep";
  version = "6.4.4";
  sha256 = "1czy9skv3jcfljwxml4nprmsxq70pav7mqhk92jg5wj1klgrz21k";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    ansiTerminal cmdargs dlist filepath regexPosix safe split stm
    stringsearch unorderedContainers
  ];
  meta = {
    homepage = "http://awgn.github.io/cgrep/";
    description = "Command line tool";
    license = self.stdenv.lib.licenses.gpl2;
    platforms = self.ghc.meta.platforms;
  };
})
