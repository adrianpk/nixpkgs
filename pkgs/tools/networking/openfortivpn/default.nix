{ stdenv, fetchFromGitHub, autoreconfHook, openssl, ppp, pkgconfig }:

with stdenv.lib;

let repo = "openfortivpn";
    version = "1.5.0";

in stdenv.mkDerivation {
  name = "${repo}-${version}";

  src = fetchFromGitHub {
    owner = "adrienverge";
    inherit repo;
    rev = "v${version}";
    sha256 = "0fm0z73afghwmbshpsn5jfbyyfzz1v8s7scwycnvsk2cgv5f4r86";
  };
  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ openssl ppp ];

  NIX_CFLAGS_COMPILE = "-Wno-error=unused-function";

  preConfigure = ''
    substituteInPlace src/tunnel.c --replace "/usr/sbin/pppd" "${ppp}/bin/pppd"
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Client for PPP+SSL VPN tunnel services";
    homepage = https://github.com/adrienverge/openfortivpn;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.madjar ];
    platforms = stdenv.lib.platforms.linux;
  };
}
