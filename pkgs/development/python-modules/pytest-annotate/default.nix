{ stdenv
, buildPythonPackage
, fetchPypi
, pyannotate
, pytest
}:

buildPythonPackage rec {
  version = "1.0.2";
  pname = "pytest-annotate";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03e4dece2d1aa91666034f1b2e8bb7a7b8c6be11baf3cf2929b26eea5c6e86f3";
  };

  propagatedBuildInputs = [ pyannotate pytest ];

  # not testing for a testing module...
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/kensho-technologies/pytest-annotate;
    description = "Generate PyAnnotate annotations from your pytest tests";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
