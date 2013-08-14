{ cabal, ansiTerminal, base64Bytestring, blazeBuilder
, blazeBuilderConduit, caseInsensitive, conduit, dataDefault
, dateCache, fastLogger, hspec, httpTypes, HUnit, network
, resourcet, stringsearch, text, time, transformers, void, wai
, waiLogger, waiTest, word8, zlib, zlibBindings, zlibConduit
}:

cabal.mkDerivation (self: {
  pname = "wai-extra";
  version = "1.3.4.3";
  sha256 = "19vj47awkazn6h4kf37f4sp4g8lhm125wjqnp1wa1wa8zlndp8wy";
  buildDepends = [
    ansiTerminal base64Bytestring blazeBuilder blazeBuilderConduit
    caseInsensitive conduit dataDefault dateCache fastLogger httpTypes
    network resourcet stringsearch text time transformers void wai
    waiLogger word8 zlibConduit
  ];
  testDepends = [
    blazeBuilder conduit dataDefault fastLogger hspec httpTypes HUnit
    text transformers wai waiTest zlib zlibBindings
  ];
  meta = {
    homepage = "http://github.com/yesodweb/wai";
    description = "Provides some basic WAI handlers and middleware";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
