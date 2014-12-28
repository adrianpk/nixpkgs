# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, filepath, polyparse, random }:

cabal.mkDerivation (self: {
  pname = "HaXml";
  version = "1.25";
  sha256 = "02l53v9c8qzkp5zzs31973pp27q4k2h04h9x3852gah78qjvnslk";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ filepath polyparse random ];
  noHaddock = true;
  meta = {
    homepage = "http://projects.haskell.org/HaXml/";
    description = "Utilities for manipulating XML documents";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
  };
})
