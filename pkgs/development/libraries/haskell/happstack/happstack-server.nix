{cabal, MaybeT, blazeHtml, happstackData, happstackUtil, hslogger,
 html, mtl, network, parsec, sendfile, syb, text, utf8String, xhtml,
 zlib} :

cabal.mkDerivation (self : {
  pname = "happstack-server";
  version = "6.1.6";
  sha256 = "1z4c2bymyyvhs47ynrlp4d2cwqws2d2isiwj82c33qcmk4znargg";
  propagatedBuildInputs = [
    MaybeT blazeHtml happstackData happstackUtil hslogger html mtl
    network parsec sendfile syb text utf8String xhtml zlib
  ];
  meta = {
    homepage = "http://happstack.com";
    description = "Web related tools and services.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [
      self.stdenv.lib.maintainers.simons
      self.stdenv.lib.maintainers.andres
    ];
  };
})
