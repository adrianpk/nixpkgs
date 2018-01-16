{ stdenv
, buildPythonPackage
, fetchPypi
, pyparsing
, graphviz
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "pydotplus";
  version = "2.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1i05cnk3yh722fdyaq0asr7z9xf7v7ikbmnpxa8j6pdqx6g5xs4i";
  };

  propagatedBuildInputs = [
    pyparsing
    graphviz
  ];

  meta = {
    homepage = https://code.google.com/p/pydot/;
    description = "An improved version of the old pydot project that provides a Python Interface to Graphviz’s Dot language";
  };
}
