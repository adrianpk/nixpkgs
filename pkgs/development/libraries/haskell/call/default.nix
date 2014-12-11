# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, bindingsPortaudio, boundingboxes, cleanUnions, colors
, controlBool, deepseq, distributive, elevator, filepath, freetype2
, GLFWB, hashable, JuicyPixels, JuicyPixelsUtil, lens, linear
, minioperational, mtl, objective, OpenGL, OpenGLRaw, random
, reflection, text, transformers, vector, WAVE
}:

cabal.mkDerivation (self: {
  pname = "call";
  version = "0.1.1.2";
  sha256 = "1g96asydq0lc07xf2c709zdv99r6ljs5a7jm6fvlyjswqnbrwy9s";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    bindingsPortaudio boundingboxes cleanUnions colors controlBool
    deepseq distributive elevator filepath freetype2 GLFWB hashable
    JuicyPixels JuicyPixelsUtil lens linear minioperational mtl
    objective OpenGL OpenGLRaw random reflection text transformers
    vector WAVE
  ];
  meta = {
    homepage = "https://github.com/fumieval/call";
    description = "The call game engine";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ fuuzetsu ];
  };
})
