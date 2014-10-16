# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, alex, binary, boxes, cpphs, dataHash, deepseq, emacs
, equivalence, filepath, geniplate, happy, hashable, hashtables
, haskeline, haskellSrcExts, mtl, parallel, QuickCheck
, STMonadTrans, strict, text, time, transformers
, unorderedContainers, xhtml, zlib
}:

cabal.mkDerivation (self: {
  pname = "Agda";
  version = "2.4.2";
  sha256 = "0pgwx79y02a08xn5f6lghw7fsc6wilab5q2gdm9r51yi9gm32aw5";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary boxes dataHash deepseq equivalence filepath geniplate
    hashable hashtables haskeline haskellSrcExts mtl parallel
    QuickCheck STMonadTrans strict text time transformers
    unorderedContainers xhtml zlib
  ];
  buildTools = [ alex cpphs emacs happy ];
  noHaddock = true;
  postInstall = ''
    $out/bin/agda -c --no-main $(find $out/share -name Primitive.agda)
    $out/bin/agda-mode compile
  '';
  meta = {
    homepage = "http://wiki.portal.chalmers.se/agda/";
    description = "A dependently typed functional programming language and proof assistant";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ fuuzetsu ];
  };
})
