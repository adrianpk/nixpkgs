{ stdenv, fetchurl, perl /*, xmlto */}:

stdenv.mkDerivation rec {
  name = "colordiff-1.0.15";

  src = fetchurl {
    sha256 = "0icx4v2h1gy08vhh3qqi2qfyfjp37vgj27hq1fnjz83bg7ly8pjr";
    urls = [
      "http://www.colordiff.org/${name}.tar.gz"
      "http://www.colordiff.org/archive/${name}.tar.gz"
    ];
  };

  buildInputs = [ perl /* xmlto */ ];

  dontBuild = 1; # do not build doc yet.

  installPhase = ''make INSTALL_DIR=/bin MAN_DIR=/share/man/man1 DESTDIR="$out" install'';

  meta = with stdenv.lib; {
    description = "Wrapper for 'diff' that produces the same output but with pretty 'syntax' highlighting";
    homepage = http://www.colordiff.org/;
    license = licenses.gpl3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainer = with maintainers; [ nckx ];
  };
}
