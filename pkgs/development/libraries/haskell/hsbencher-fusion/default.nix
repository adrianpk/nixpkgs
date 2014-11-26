# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, criterion, csv, dataDefault, filepath, handaGdata
, hsbencher, httpConduit, mtl, network, statistics, text, time
}:

cabal.mkDerivation (self: {
  pname = "hsbencher-fusion";
  version = "0.3.3";
  sha256 = "0vp1biv5jwac3bhj7qxl8x3bw73436qn284fippmlr6f54c15yw8";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    criterion csv dataDefault filepath handaGdata hsbencher httpConduit
    mtl network statistics text time
  ];
  doCheck = false;
  meta = {
    description = "Backend for uploading benchmark data to Google Fusion Tables";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
