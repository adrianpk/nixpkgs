{ stdenv, fetchgit, autoreconfHook, pkgconfig, libogg }:

stdenv.mkDerivation rec {
  name = "tremor-git-${src.rev}";

  src = fetchgit {
    url = https://git.xiph.org/tremor.git;
    rev = "562307a4a7082e24553f3d2c55dab397a17c4b4f";
    sha256 = "0m07gq4zfgigsiz8b518xyb19v7qqp76qmp7lb262825vkqzl3zq";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  propagatedBuildInputs = [ libogg ];

  preConfigure = ''
    sed -i /XIPH_PATH_OGG/d configure
  '';

  meta = {
    homepage = http://xiph.org/tremor/;
    description = "Fixed-point version of the Ogg Vorbis decoder";
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.unix;
  };
}
