{ cabal, haskellSrcExts, haskellSrcMeta, pcreLight }:

cabal.mkDerivation (self: {
  pname = "rex";
  version = "0.5.1";
  sha256 = "18g09pg7hhj052v72vncjvy900h3xhza8hl2g3akad8asn9k6jl6";
  buildDepends = [ haskellSrcExts haskellSrcMeta pcreLight ];
  meta = {
    homepage = "http://github.com/mgsloan/rex";
    description = "A quasi-quoter for typeful results of regex captures";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
