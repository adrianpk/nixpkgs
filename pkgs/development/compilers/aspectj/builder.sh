source $stdenv/setup

export JAVA_HOME=$jre

cat >> props <<EOF
output.dir=$out
context.javaPath=$jre
EOF

ensureDir $out
$jre/bin/java -jar $src -text props

echo "Removing files at top level"
for file in $out/*
do
  if test -f $file ; then
    rm $file
  fi
done

cat >> $out/bin/ajc-env <<EOF
#! $SHELL

export CLASSPATH=$CLASSPATH:.:/pkg/aspectj/lib/aspectjrt.jar
EOF

chmod u+x $out/bin/ajc-env