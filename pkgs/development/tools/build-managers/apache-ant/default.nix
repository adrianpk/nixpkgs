{ fetchurl, stdenv, makeWrapper }:

let version = "1.9.3"; in

stdenv.mkDerivation {
  name = "ant-${version}";

  buildInputs = [ makeWrapper ];

  src = fetchurl {
    url = "mirror://apache/ant/binaries/apache-ant-${version}-bin.tar.bz2";
    sha1 = "efcf206e24b0dd1583c501182ad163af277951a4";
  };

  contrib = fetchurl {
    url = mirror://sourceforge/ant-contrib/ant-contrib-1.0b3-bin.tar.bz2;
    sha256 = "96effcca2581c1ab42a4828c770b48d54852edf9e71cefc9ed2ffd6590571ad1";
  };

  installPhase =
    ''
      mkdir -p $out/bin $out/lib/ant
      mv * $out/lib/ant/

      # Get rid of the manual (35 MiB).  Maybe we should put this in a
      # separate output.  Also get rid of the Ant scripts since we
      # provide our own.
      rm -rf $out/lib/ant/{manual,bin,WHATSNEW}

      # Install ant-contrib.
      unpackFile $contrib
      cp -p ant-contrib/ant-contrib-*.jar $out/lib/ant/lib/

      cat >> $out/bin/ant <<EOF
      #! ${stdenv.shell} -e

      ANT_HOME=$out/lib/ant

      # Find the JDK by looking for javac.  As a fall-back, find the
      # JRE by looking for java.  The latter allows just the JRE to be
      # used with (say) ECJ as the compiler.  Finally, allow the GNU
      # JVM.
      if [ -z "\$JAVA_HOME" ]; then
          for i in javac java gij; do
              if p="\$(type -p \$i)"; then
                  export JAVA_HOME="\$(dirname \$(dirname \$(readlink -f \$p)))"
                  break
              fi
          done
          if [ -z "\$JAVA_HOME" ]; then
              echo "\$0: cannot find the JDK or JRE" >&2
              exit 1
          fi
      fi

      if [ -z \$NIX_JVM ]; then
          if [ -e \$JAVA_HOME/bin/java ]; then
              NIX_JVM=\$JAVA_HOME/bin/java
          elif [ -e \$JAVA_HOME/bin/gij ]; then
              NIX_JVM=\$JAVA_HOME/bin/gij
          else
              NIX_JVM=java
          fi
      fi

      LOCALCLASSPATH="\$ANT_HOME/lib/ant-launcher.jar\''${LOCALCLASSPATH:+:}\$LOCALCLASSPATH"

      if [ -e \$JAVA_HOME/lib/tools.jar ]; then
          LOCALCLASSPATH="\$JAVA_HOME/lib/tools.jar\''${LOCALCLASSPATH:+:}\$LOCALCLASSPATH"
      fi

      exec \$NIX_JVM \$NIX_ANT_OPTS \$ANT_OPTS -classpath "\$LOCALCLASSPATH" \
          -Dant.home=\$ANT_HOME -Dant.library.dir="\$ANT_LIB" \
          org.apache.tools.ant.launch.Launcher \$NIX_ANT_ARGS \$ANT_ARGS \
          -cp "\$CLASSPATH" "\$@"
      EOF

      chmod +x $out/bin/ant
    ''; # */

  meta = {
    homepage = http://ant.apache.org/;
    description = "A Java-based build tool";
    license = stdenv.lib.licenses.asl20;
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.all;
  };
}
