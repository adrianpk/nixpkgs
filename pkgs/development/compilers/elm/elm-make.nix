# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, ansiWlPprint, binary, blazeHtml, blazeMarkup, elmCompiler
, elmPackage, filepath, mtl, optparseApplicative_0_10_0, text
}:

cabal.mkDerivation (self: {
  pname = "elm-make";
  version = "0.1";
  sha256 = "1hrc8bzfqzrcmkzqcampxkn5m113blfp4095h6c2xnadiicbvwdy";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    ansiWlPprint binary blazeHtml blazeMarkup elmCompiler elmPackage
    filepath mtl optparseApplicative_0_10_0 text
  ];
  meta = {
    homepage = "http://elm-lang.org";
    description = "A build tool for Elm projects";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
