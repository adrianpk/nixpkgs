{cabal, ghcPaths, alex, happy, makeWrapper}:

cabal.mkDerivation (self : {
  pname = "haddock";
  version = "2.7.2"; # Haskell Platform 2010.1.0.0 and 2010.2.0.0
  name = self.fname;
  sha256 = "4eaaaf62785f0ba3d37ba356cfac4679faef91c0902d8cdbf42837cbe5daab82";
  extraBuildInputs = [alex happy makeWrapper];
  propagatedBuildInputs = [ghcPaths];

  postInstall = ''
   wrapProgram $out/bin/haddock --add-flags "\$(${self.ghc.GHCGetPackages} ${self.ghc.ghcVersion} \"\$(dirname \$0)\" \"--optghc=-package-conf --optghc=\")"
  '';

  meta = {
    description = "a tool for automatically generating documentation from annotated Haskell source code";
  };
})
