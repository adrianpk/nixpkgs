#!@shell@

if [ -e ~/.config/freeorion/config.xml ]; then
  @libxsltBin@/bin/xsltproc -o ~/.config/freeorion/config.xml @out@/fixpaths/fix-paths.xslt ~/.config/freeorion/config.xml
fi
exit 0
