{ cabal, async, base64Bytestring, blazeBuilder, caseInsensitive
, cookie, dataDefaultClass, deepseq, exceptions, filepath, hspec
, httpTypes, mimeTypes, monadControl, network, publicsuffixlist
, random, streamingCommons, text, time, transformers, zlib
}:

cabal.mkDerivation (self: {
  pname = "http-client";
  version = "0.3.3.1";
  sha256 = "0zzh4vr563f8rb51b64gcwmal7gswif8ndsf2x5kw6f7q55md0dw";
  buildDepends = [
    base64Bytestring blazeBuilder caseInsensitive cookie
    dataDefaultClass deepseq exceptions filepath httpTypes mimeTypes
    network publicsuffixlist random streamingCommons text time
    transformers
  ];
  testDepends = [
    async base64Bytestring blazeBuilder caseInsensitive deepseq hspec
    httpTypes monadControl network streamingCommons text time
    transformers zlib
  ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/snoyberg/http-client";
    description = "An HTTP client engine, intended as a base layer for more user-friendly packages";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
