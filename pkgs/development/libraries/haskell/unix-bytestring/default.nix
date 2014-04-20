{ cabal }:

cabal.mkDerivation (self: {
  pname = "unix-bytestring";
  version = "0.3.7.2";
  sha256 = "0n1i7pcdwhs0wz6spf3pndr8i74qn0cdzr3p46w4r4mvvwr76i2s";
  meta = {
    homepage = "http://code.haskell.org/~wren/";
    description = "Unix/Posix-specific functions for ByteStrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
