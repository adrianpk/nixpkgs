# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, binary, deepseq, mtl, primitive, transformers, vector
, zlib
}:

cabal.mkDerivation (self: {
  pname = "JuicyPixels";
  version = "3.2";
  sha256 = "1z4i0464zdijv54b7wzc55zrp8h67ahm6mrdk7a6gi2qm0nihmy5";
  buildDepends = [
    binary deepseq mtl primitive transformers vector zlib
  ];
  meta = {
    homepage = "https://github.com/Twinside/Juicy.Pixels";
    description = "Picture loading/serialization (in png, jpeg, bitmap, gif, tga, tiff and radiance)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
