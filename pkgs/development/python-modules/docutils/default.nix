{ lib
, fetchurl
, buildPythonPackage
, isPy3k
, python
}:

buildPythonPackage rec {
  pname = "docutils";
  version = "0.14";

  src = fetchurl {
    url = "mirror://sourceforge/docutils/${pname}.tar.gz";
    sha256 = "0x22fs3pdmr42kvz6c654756wja305qv6cx1zbhwlagvxgr4xrji";
  };

  checkPhase = ''
    LANG="en_US.UTF-8" ${python.interpreter} ${if isPy3k then "test3/alltests.py" else "test/alltests.py"}
  '';

  # Create symlinks lacking a ".py" suffix, many programs depend on these names
  postFixup = ''
    for f in $out/bin/*.py; do
      ln -s $(basename $f) $out/bin/$(basename $f .py)
    done
  '';

  meta = {
    description = "Docutils -- Python Documentation Utilities";
    homepage = http://docutils.sourceforge.net/;
    maintainers = with lib.maintainers; [ garbas AndersonTorres ];
  };
}
