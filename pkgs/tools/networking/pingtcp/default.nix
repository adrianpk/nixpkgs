{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "pingtcp-${version}";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "LanetNetwork";
    repo = "pingtcp";
    sha256 = "1cv84n30y03s1b83apxxyn2jv5ss1pywsahrfrpkb6zcgzzrcqn8";
    rev = "refs/tags/v${version}";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  enableParallelBuilding = true;

  doCheck = false;

  postInstall = ''
    install -Dm644 {..,$out/share/doc/pingtcp}/README.md
  '';

  meta = with stdenv.lib; {
    description = "Measure TCP handshake time";
    homepage = https://github.com/LanetNetwork/pingtcp;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
