# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, boundingboxes, colors, controlBool, filepath, free
, freetype2, GLFWB, hashable, JuicyPixels, JuicyPixelsUtil, lens
, linear, mtl, OpenGL, OpenGLRaw, random, reflection, transformers
, vector, void
}:

cabal.mkDerivation (self: {
  pname = "free-game";
  version = "1.1.79";
  sha256 = "0dlkkcbi7442cbl3ibzy234alaixh34hkc20wr7p75z47w1r5fbx";
  buildDepends = [
    boundingboxes colors controlBool filepath free freetype2 GLFWB
    hashable JuicyPixels JuicyPixelsUtil lens linear mtl OpenGL
    OpenGLRaw random reflection transformers vector void
  ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/fumieval/free-game";
    description = "Create games for free";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ fuuzetsu ];
  };
})
