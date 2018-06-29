{stdenv, fetchurl, jre}:

stdenv.mkDerivation rec {
  name = "antlr-${version}";
  version = "4.7.1";
  src = fetchurl {
    url ="https://www.antlr.org/download/antlr-${version}-complete.jar";
    sha256 = "1236gwnzchama92apb2swmklnypj01m7bdwwfvwvl8ym85scw7gl";
  };

  unpackPhase = "true";
 
  installPhase = ''
    mkdir -p "$out"/{share/java,bin}
    cp "$src" "$out/share/java/antlr-${version}-complete.jar"

    echo "#! ${stdenv.shell}" >> "$out/bin/antlr"
    echo "'${jre}/bin/java' -cp '$out/share/java/antlr-${version}-complete.jar:$CLASSPATH' -Xmx500M org.antlr.v4.Tool \"\$@\"" >> "$out/bin/antlr"
    
    echo "#! ${stdenv.shell}" >> "$out/bin/grun"
    echo "'${jre}/bin/java' -cp '$out/share/java/antlr-${version}-complete.jar:$CLASSPATH' org.antlr.v4.gui.TestRig \"\$@\"" >> "$out/bin/grun"

    chmod a+x "$out/bin/antlr" "$out/bin/grun"
    ln -s "$out/bin/antlr"{,4}
  '';

  inherit jre;

  meta = with stdenv.lib; {
    description = "Powerful parser generator";
    longDescription = ''
      ANTLR (ANother Tool for Language Recognition) is a powerful parser
      generator for reading, processing, executing, or translating structured
      text or binary files. It's widely used to build languages, tools, and
      frameworks. From a grammar, ANTLR generates a parser that can build and
      walk parse trees.
    '';
    homepage = http://www.antlr.org/;
    platforms = platforms.unix;
  };
}
