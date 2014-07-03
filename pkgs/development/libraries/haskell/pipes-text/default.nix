{ cabal, pipes, pipesBytestring, pipesGroup, pipesParse, pipesSafe
, streamingCommons, text, transformers
}:

cabal.mkDerivation (self: {
  pname = "pipes-text";
  version = "0.0.0.12";
  sha256 = "18xf0rhshbl03js50n98k96692w98j0j0dfyi67780i08c39dq6m";
  buildDepends = [
    pipes pipesBytestring pipesGroup pipesParse pipesSafe
    streamingCommons text transformers
  ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/michaelt/text-pipes";
    description = "Text pipes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
