# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, aesonPretty, ansiWlPprint, binary, elmCompiler
, filepath, HTTP, httpClient, httpClientTls, httpTypes, mtl
, network, optparseApplicative, text, time, unorderedContainers
, vector, zipArchive
}:

cabal.mkDerivation (self: {
  pname = "elm-package";
  version = "0.4";
  sha256 = "0vsq87imyvs1sa2n4z41b6qswy2cknxsg4prhwc9r7lvyljkmn03";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson aesonPretty ansiWlPprint binary elmCompiler filepath HTTP
    httpClient httpClientTls httpTypes mtl network optparseApplicative
    text time unorderedContainers vector zipArchive
  ];
  meta = {
    homepage = "http://github.com/elm-lang/elm-package";
    description = "Package manager for Elm libraries";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
