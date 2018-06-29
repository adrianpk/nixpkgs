{ stdenv, fetchurl, makeWrapper, jre, gnugrep, coreutils }:

stdenv.mkDerivation rec {
  name = "scala-2.12.6";

  src = fetchurl {
    url = "https://www.scala-lang.org/files/archive/${name}.tgz";
    sha256 = "05ili2959yrshqi44wpmwy0dyfm4kvp6i8mlbnj1xvc5b9649iqs";
  };

  propagatedBuildInputs = [ jre ] ;
  buildInputs = [ makeWrapper ] ;

  installPhase = ''
    mkdir -p $out
    rm "bin/"*.bat
    mv * $out

    # put docs in correct subdirectory
    mkdir -p $out/share/doc
    mv $out/doc $out/share/doc/scala

    for p in $(ls $out/bin/) ; do
      wrapProgram $out/bin/$p \
        --prefix PATH ":" ${coreutils}/bin \
        --prefix PATH ":" ${gnugrep}/bin \
        --prefix PATH ":" ${jre}/bin \
        --set JAVA_HOME ${jre}
    done
  '';

  meta = {
    description = "General purpose programming language";
    longDescription = ''
      Scala is a general purpose programming language designed to express
      common programming patterns in a concise, elegant, and type-safe way.
      It smoothly integrates features of object-oriented and functional
      languages, enabling Java and other programmers to be more productive.
      Code sizes are typically reduced by a factor of two to three when
      compared to an equivalent Java application.
    '';
    homepage = https://www.scala-lang.org/;
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.all;
  };
}
