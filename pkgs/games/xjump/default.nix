{ stdenv, fetchFromGitHub, autoconf, automake, libX11, libXt, libXpm, libXaw, localStateDir?"/var" }:

stdenv.mkDerivation rec {
  name = "xjump-${version}";
  version = "2.9.3";
  src = fetchFromGitHub {
    owner = "hugomg";
    repo = "xjump";
    rev = "e7f20fb8c2c456bed70abb046c1a966462192b80";
    sha256 = "0hq4739cvi5a47pxdc0wwkj2lmlqbf1xigq0v85qs5bq3ixmq2f7";
  };
  nativeBuildInputs = [ autoconf automake ];
  buildInputs = [ libX11 libXt libXpm libXaw ];
  preConfigure = "autoreconf --install";
  configureFlags = ["--localstatedir=${localStateDir}"];

  meta = with stdenv.lib; {
    description = "The falling tower game";
    maintainers = with maintainers; [ pmeunier ];
  };
}
