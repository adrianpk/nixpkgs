{ cabal, blazeBuilder, blazeBuilderConduit, Cabal, caseInsensitive
, conduit, httpTypes, liftedBase, network, simpleSendfile
, transformers, unixCompat, wai
}:

cabal.mkDerivation (self: {
  pname = "warp";
  version = "1.1.0";
  sha256 = "1an2j89422rcvrvrmhg1hwj8vpikjj5xdzb3h37rjsfj6qlqy5cf";
  buildDepends = [
    blazeBuilder blazeBuilderConduit Cabal caseInsensitive conduit
    httpTypes liftedBase network simpleSendfile transformers unixCompat
    wai
  ];
  meta = {
    homepage = "http://github.com/yesodweb/wai";
    description = "A fast, light-weight web server for WAI applications";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
