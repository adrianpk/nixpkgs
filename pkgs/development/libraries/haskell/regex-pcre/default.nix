{ cabal, pcre, regexBase }:

cabal.mkDerivation (self: {
  pname = "regex-pcre";
  version = "0.94.3";
  sha256 = "0ljng60s05ssy8pi4qnpcx5c1wrn6m35d77lq0xyafmj68cg4a2r";
  buildDepends = [ regexBase ];
  extraLibraries = [ pcre ];
  patchPhase = ''
    sed -i -e '/Include-Dirs:/d' -e '/Extra-Lib-Dirs:/d' regex-pcre.cabal
  '';
  meta = {
    homepage = "http://sourceforge.net/projects/lazy-regex";
    description = "Replaces/Enhances Text.Regex";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
