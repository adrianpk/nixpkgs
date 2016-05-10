{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "dev86-${version}";
  version = "0.16.21";

  src = fetchurl {
    url = "http://v3.sk/~lkundrak/dev86/Dev86src-${version}.tar.gz";
    sha256 = "154dyr2ph4n0kwi8yx0n78j128kw29rk9r9f7s2gddzrdl712jr3";
  };

  makeFlags = "PREFIX=$(out)";

  meta = {
    description = "Linux 8086 development environment";
    homepage = http://v3.sk/~lkundrak/dev86/;
  };
}
