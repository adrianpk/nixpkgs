{ cabal, aesonUtils, caseInsensitive, dataDefault
, exceptionTransformers, httpConduit, httpTypes, hxt
, hxtPickleUtils, monadControl, mtl, primitive, resourcet
, restTypes, tostring, transformersBase, uriEncode, utf8String
}:

cabal.mkDerivation (self: {
  pname = "rest-client";
  version = "0.4";
  sha256 = "18mvmp4c5zznph8q5ash6224wig5kwvb6v19dkn39n4l72cdq7wm";
  buildDepends = [
    aesonUtils caseInsensitive dataDefault exceptionTransformers
    httpConduit httpTypes hxt hxtPickleUtils monadControl mtl primitive
    resourcet restTypes tostring transformersBase uriEncode utf8String
  ];
  meta = {
    description = "Utility library for use in generated API client libraries";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
