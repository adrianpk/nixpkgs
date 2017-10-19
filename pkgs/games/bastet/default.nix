{ stdenv, fetchFromGitHub, fetchpatch, ncurses, boost }:

stdenv.mkDerivation rec {
  name = "bastet-${version}";
  version = "0.43.2";
  buildInputs = [ ncurses boost ];

  src = fetchFromGitHub {
    owner = "fph";
    repo = "bastet";
    rev = version;
    sha256 = "09kamxapm9jw9przpsgjfg33n9k94bccv65w95dakj0br33a75wn";
  };

  patches = [
    # Compatibility with new Boost
    (fetchpatch {
      url = "https://github.com/fph/bastet/commit/0e03f8d4d6bc6949cf1c447e632ce0d1b98c4be1.patch";
      sha256 = "1475hisbm44jirsrhdlnddppsyn83xmvcx09gfkm9drcix05alzj";
    })
  ];

  installPhase = ''
    mkdir -p "$out"/bin
    cp bastet "$out"/bin/
    mkdir -p "$out"/share/man/man6
    cp bastet.6 "$out"/share/man/man6
  '';

  meta = with stdenv.lib; {
    description = "Tetris clone with 'bastard' block-choosing AI";
    homepage = http://fph.altervista.org/prog/bastet.html;
    license = licenses.gpl3;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}
