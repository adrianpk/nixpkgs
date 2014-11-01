# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, base64Bytestring, blazeBuilder, HaXml, HTTP, mtl, network
, networkUri, time, utf8String
}:

cabal.mkDerivation (self: {
  pname = "haxr";
  version = "3000.10.3.1";
  sha256 = "0alvrsk85f1l79hfa9shagjckp4sx835l9734ab2izfv50mxx7gm";
  buildDepends = [
    base64Bytestring blazeBuilder HaXml HTTP mtl network networkUri
    time utf8String
  ];
  jailbreak = true;
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/HaXR";
    description = "XML-RPC client and server library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
