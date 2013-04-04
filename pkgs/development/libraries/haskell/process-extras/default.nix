{ cabal, deepseq, text }:

cabal.mkDerivation (self: {
  pname = "process-extras";
  version = "0.2.0";
  sha256 = "0mr4f2v19qz6d6jhffz9gky0ykdqwl8c11adbdm04wm2a3xsvf7g";
  buildDepends = [ deepseq text ];
  meta = {
    homepage = "https://github.com/davidlazar/process-extras";
    description = "Process extras";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
