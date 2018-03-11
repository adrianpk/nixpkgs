{ stdenv, fetchFromGitHub, cmake, qt4 ? null
, withQt5 ? false, qtbase ? null, qttools ? null
, darwin ? null
}:

assert withQt5 -> qtbase != null;
assert withQt5 -> qttools != null;
assert stdenv.isDarwin -> darwin != null;

stdenv.mkDerivation rec {
  name = "qtkeychain-${if withQt5 then "qt5" else "qt4"}-${version}";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "frankosterfeld";
    repo = "qtkeychain";
    rev = "v${version}";
    sha256 = "04v6ymkw7qd1pf9lwijgqrl89w2hhsnqgz7dm4cdrh8i8dffpn52";
  };

  cmakeFlags = [ "-DQT_TRANSLATIONS_DIR=share/qt/translations" ]
    ++ stdenv.lib.optional stdenv.isDarwin [
       # correctly detect the compiler
       # for details see cmake --help-policy CMP0025
       "-DCMAKE_POLICY_DEFAULT_CMP0025=NEW"
       ]
   ;

  nativeBuildInputs = [ cmake ];

  buildInputs = if withQt5 then [ qtbase qttools ] else [ qt4 ]
    ++ stdenv.lib.optional stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
         CoreFoundation Security
    ])
  ;

  meta = {
    description = "Platform-independent Qt API for storing passwords securely";
    homepage = https://github.com/frankosterfeld/qtkeychain;
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.unix;
  };
}
