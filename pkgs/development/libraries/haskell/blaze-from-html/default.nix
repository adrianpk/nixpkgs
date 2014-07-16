{ cabal, filepath, tagsoup }:

cabal.mkDerivation (self: {
  pname = "blaze-from-html";
  version = "0.3.2.1";
  sha256 = "1li3zxrgwj5rgk894d9zwfxnx5dfjzkvjlcyck2g7s0awfp2kq4s";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ filepath tagsoup ];
  meta = {
    homepage = "http://jaspervdj.be/blaze";
    description = "Tool to convert HTML to BlazeHtml code";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
