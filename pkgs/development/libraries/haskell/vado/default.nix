# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, attoparsec, filepath, QuickCheck, text }:

cabal.mkDerivation (self: {
  pname = "vado";
  version = "0.0.3";
  sha256 = "1s6fb19p3lc6g13ryh7bmxciv62v8m0ihvzrymsj0nn6jghiys5f";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ attoparsec filepath text ];
  testDepends = [ attoparsec filepath QuickCheck text ];
  meta = {
    homepage = "https://github.com/hamishmack/vado";
    description = "Runs commands on remote machines using ssh";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
