{ stdenv
, fetchPypi
, pythonOlder
, buildPythonPackage
, docutils
, mock
, nose
, coverage
, wheel
, unittest2
, botocore
, futures
}:

buildPythonPackage rec {
  pname = "s3transfer";
  version = "0.1.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "90dc18e028989c609146e241ea153250be451e05ecc0c2832565231dacdf59c1";
  };

  foo = 1;

  propagatedBuildInputs =
    [ botocore
    ] ++ stdenv.lib.optional (pythonOlder "3") futures;

  buildInputs = [
    docutils
    mock
    nose
    coverage
    wheel
    unittest2
  ];

  checkPhase = ''
    pushd s3transfer/tests
    nosetests -v unit/ functional/
    popd
  '';

  # version on pypi has no tests/ dir
  doCheck = false;

  meta = {
    homepage = https://github.com/boto/s3transfer;
    license = stdenv.lib.licenses.asl20;
    description = "A library for managing Amazon S3 transfers";
  };
}
