{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libogg-1.3.2";

  src = fetchurl {
    url = "http://downloads.xiph.org/releases/ogg/${name}.tar.xz";
    sha256 = "16z74q422jmprhyvy7c9x909li8cqzmvzyr8cgbm52xcsp6pqs1z";
  };

  outputs = [ "out" "dev" "doc" ];

  meta = with stdenv.lib; {
    homepage = https://xiph.org/ogg/;
    license = licenses.bsd3;
    maintainers = [ maintainers.ehmry ];
    platforms = platforms.all;
  };
}
