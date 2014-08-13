{ cabal, base64String, Crypto, mimeMail, mtl, network, text }:

cabal.mkDerivation (self: {
  pname = "HaskellNet";
  version = "0.3.1";
  sha256 = "168w6y5rizszq1428amxbkhww65sy3b7czxpjyrzzq3dhjn517nr";
  buildDepends = [ base64String Crypto mimeMail mtl network text ];
  meta = {
    homepage = "https://github.com/jtdaugherty/HaskellNet";
    description = "Client support for POP3, SMTP, and IMAP";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
