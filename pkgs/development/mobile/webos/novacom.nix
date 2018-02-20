{ stdenv, fetchFromGitHub, webos, cmake, pkgconfig }:

stdenv.mkDerivation rec {
  name = "novacom-${version}";
  version = "18";

  src = fetchFromGitHub {
    owner = "openwebos";
    repo = "novacom";
    rev = "submissions/${version}";
    sha256 = "12s6g7l20kakyjlhqpli496miv2kfsdp17lcwhdrzdxvxl6hnf4n";
  };

  nativeBuildInputs = [ cmake pkgconfig webos.cmake-modules ];

  postInstall = ''
    install -Dm755 -t $out/bin ../scripts/novaterm
    substituteInPlace $out/bin/novaterm --replace "exec novacom" "exec $out/bin/novacom"
  '';

  meta = with stdenv.lib; {
    description = "Utility for communicating with WebOS devices";
    license = licenses.asl20;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.linux;
  };
}
