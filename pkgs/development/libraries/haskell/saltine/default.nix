# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, libsodium, profunctors, QuickCheck, testFramework
, testFrameworkQuickcheck2, vector
}:

cabal.mkDerivation (self: {
  pname = "saltine";
  version = "0.0.0.3";
  sha256 = "1xjpjblxlpziyyz74ldaqh04shvy2qi34sc6b3232wpc0kyl5s8y";
  buildDepends = [ profunctors ];
  testDepends = [
    QuickCheck testFramework testFrameworkQuickcheck2 vector
  ];
  extraLibraries = [ libsodium ];
  meta = {
    description = "Cryptography that's easy to digest (NaCl/libsodium bindings)";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ fuuzetsu ];
  };
})
