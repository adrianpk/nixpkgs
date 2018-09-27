{ stdenv, fetchFromGitHub, zlib, curl, expat, fuse, openssl
, autoreconfHook, python3
}:

stdenv.mkDerivation rec {
  version = "3.7.17";
  name = "afflib-${version}";

  src = fetchFromGitHub {
    owner = "sshock";
    repo = "AFFLIBv3";
    rev = "v${version}";
    sha256 = "11q20n6p5nvwmd9wwk0addlfxpxagf47ly89scn3jvc7k484ksan";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ zlib curl expat fuse openssl python3 ];

  meta = {
    homepage = http://afflib.sourceforge.net/;
    description = "Advanced forensic format library";
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.bsdOriginal;
    maintainers = [ stdenv.lib.maintainers.raskin ];
    inherit version;
    downloadPage = "https://github.com/sshock/AFFLIBv3/tags";
  };
}
