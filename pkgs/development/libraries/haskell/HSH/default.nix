# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, filepath, hslogger, MissingH, mtl, regexBase, regexCompat
, regexPosix
}:

cabal.mkDerivation (self: {
  pname = "HSH";
  version = "2.1.1";
  sha256 = "14aijsafd8mkh46dy071haix16p31ppdn2s3r9kxdbjjas6qh13g";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    filepath hslogger MissingH mtl regexBase regexCompat regexPosix
  ];
  meta = {
    homepage = "http://software.complete.org/hsh";
    description = "Library to mix shell scripting with Haskell programs";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ andres ];
  };
})
