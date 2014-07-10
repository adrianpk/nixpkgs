{ cabal }:

cabal.mkDerivation (self: {
  pname = "loch-th";
  version = "0.2.1";
  sha256 = "1kfrjsgzq6wl749n2wm1fhwwigjxcd9lww7whiwjrbmhiz5ism3p";
  meta = {
    homepage = "https://github.com/liskin/loch-th";
    description = "Support for precise error locations in source files (Template Haskell version)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
