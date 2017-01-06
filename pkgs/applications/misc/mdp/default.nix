{ stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  version = "1.0.9";
  name = "mdp-${version}";

  src = fetchFromGitHub {
    owner = "visit1985";
    repo = "mdp";
    rev = version;
    sha256 = "183flp52zfady4f8f3vgapr5f5k6cvanmj2hw293v6pw71qnafmd";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  buildInputs = [ ncurses ];

  meta = with stdenv.lib; {
    homepage = https://github.com/visit1985/mdp;
    description = "A command-line based markdown presentation tool";
    maintainers = with maintainers; [ matthiasbeyer vrthra ];
    license = licenses.gpl3;
    platforms = with platforms; unix;
  };
}
