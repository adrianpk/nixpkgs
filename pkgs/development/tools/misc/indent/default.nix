{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "indent-2.2.10";

  src = fetchurl {
    url = "ftp://ftp.gnu.org/gnu/indent/${name}.tar.gz";
    sha256 = "0f9655vqdvfwbxvs1gpa7py8k1z71aqh8hp73f65vazwbfz436wa";
  };

  preBuild =
    ''
      sed -e '/extern FILE [*]output/i#ifndef OUTPUT_DEFINED_ELSEWHERE' -i src/indent.h
      sed -e '/extern FILE [*]output/a#endif' -i src/indent.h
      sed -e '1i#define OUTPUT_DEFINED_ELSEWHERE 1' -i src/output.c
    '';
    
  meta = {
    homepage = http://www.gnu.org/software/indent/;
    description = "A source code reformatter";
    license = "GPLv3+";
  };
}
