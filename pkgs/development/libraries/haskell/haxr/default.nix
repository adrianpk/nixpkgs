{ cabal, base64Bytestring, blazeBuilder, HaXml, HTTP, mtl, network
, time, utf8String
}:

cabal.mkDerivation (self: {
  pname = "haxr";
  version = "3000.10.3";
  sha256 = "082w86vawjiqz589s3gmawssd0b43b1vcw0h6cndadwww8yc35bg";
  buildDepends = [
    base64Bytestring blazeBuilder HaXml HTTP mtl network time
    utf8String
  ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/HaXR";
    description = "XML-RPC client and server library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
