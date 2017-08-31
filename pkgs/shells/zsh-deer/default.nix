{ stdenv, fetchFromGitHub, perl }:

let
  version = "1.4";
  name = "deer-${version}";
in stdenv.mkDerivation {
  inherit name;

  src = fetchFromGitHub {
    owner = "Vifon";
    repo = "deer";
    rev = "v${version}";
    sha256 = "1xnbnbi0zk2xsyn8dqsmyxqlfnl36pb1wwibnlp0dxixw6sfymyl";
  };

  prePatch = ''
    sed -i '157s/perl/'\
    "$(echo ${perl}/bin/perl | sed 's/\//\\\//g')"'/' \
    deer
  '';

  patches = [ ./realpath.patch ];

  installPhase = ''
    mkdir -p $out/share/zsh/site-functions/
    cp deer $out/share/zsh/site-functions/
  '';

  meta = with stdenv.lib; {
    description = "Ranger-like file navigation for zsh";
    homepage = "https://github.com/Vifon/deer";
    license = licenses.gpl3Plus;
    maintainers = maintainers.vyp;
    platforms = platforms.unix;
  };
}
