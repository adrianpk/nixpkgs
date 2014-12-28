# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, baseCompat, fetchgit, hspec, hspecExpectations
, libsystemdJournal, mimeMail, mtl, pipes, pipesBytestring
, pipesSafe, QuickCheck, silently, stringConversions, temporary
, text, time, unorderedContainers, yaml
}:

cabal.mkDerivation (self: {
  pname = "journal-mailer";
  version = "0.1.1.0";
  src = fetchgit {
    url = "https://github.com/zalora/journal-mailer.git";
    sha256 = "cd28b39746fd8a9652eb5d4dc5dcfd66704826d1ee466572fb47925b054cd07b";
    rev = "ab1b4df09e7ddbe139959374437331cdddf754b2";
  };
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    baseCompat libsystemdJournal mimeMail pipes pipesBytestring
    pipesSafe stringConversions text time unorderedContainers yaml
  ];
  testDepends = [
    baseCompat hspec hspecExpectations libsystemdJournal mimeMail mtl
    pipes pipesBytestring pipesSafe QuickCheck silently
    stringConversions temporary text time unorderedContainers yaml
  ];
  meta = {
    description = "Sends out emails for every severe message logged to systemd's journal";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.tv ];
  };
})
