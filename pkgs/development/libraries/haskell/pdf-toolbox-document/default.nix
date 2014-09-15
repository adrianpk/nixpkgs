{ cabal, cipherRc4, cryptohash, ioStreams, pdfToolboxContent
, pdfToolboxCore, text, transformers
}:

cabal.mkDerivation (self: {
  pname = "pdf-toolbox-document";
  version = "0.0.3.0";
  sha256 = "0y1kb2hf420jx6r81c431avgar32wzx2xr747akcs4rypf6w53fn";
  buildDepends = [
    cipherRc4 cryptohash ioStreams pdfToolboxContent pdfToolboxCore
    text transformers
  ];
  meta = {
    homepage = "https://github.com/Yuras/pdf-toolbox";
    description = "A collection of tools for processing PDF files";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ ianwookim ];
  };
})
