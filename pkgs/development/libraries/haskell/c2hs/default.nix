# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, dlist, filepath, HUnit, languageC, shelly, testFramework
, testFrameworkHunit, text, transformers, yaml
}:

cabal.mkDerivation (self: {
  pname = "c2hs";
  version = "0.18.1";
  sha256 = "17miqihfidzd1nqdswnd7j0580jlv2pj19wxlx8vb3dc5wga58xd";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ dlist filepath languageC shelly text yaml ];
  testDepends = [
    filepath HUnit shelly testFramework testFrameworkHunit text
    transformers
  ];
  jailbreak = true;
  doCheck = false;
  meta = {
    homepage = "https://github.com/haskell/c2hs";
    description = "C->Haskell FFI tool that gives some cross-language type safety";
    license = self.stdenv.lib.licenses.gpl2;
    platforms = self.ghc.meta.platforms;
  };
})
