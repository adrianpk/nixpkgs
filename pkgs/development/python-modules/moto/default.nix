{ stdenv, buildPythonPackage, fetchPypi, jinja2, werkzeug, flask
, requests, pytz, backports_tempfile, cookies, jsondiff, botocore, aws-xray-sdk, docker
, six, boto, httpretty, xmltodict, nose, sure, boto3, freezegun, dateutil, mock, pyaml }:

buildPythonPackage rec {
  pname = "moto";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e6b25a32b61ba97bbc2236960ad6865ab111962a927de720c907475adff4499b";
  };

  postPatch = ''
    # dateutil upper bound was just to keep compatibility with Python 2.6
    # see https://github.com/spulec/moto/pull/1519 and https://github.com/boto/botocore/pull/1402
    # regarding aws-xray-sdk: https://github.com/spulec/moto/commit/31eac49e1555c5345021a252cb0c95043197ea16
    substituteInPlace setup.py \
      --replace "python-dateutil<2.7.0" "python-dateutil<3.0.0" \
      --replace "aws-xray-sdk<0.96," "aws-xray-sdk"
  '';

  propagatedBuildInputs = [
    aws-xray-sdk
    boto
    boto3
    dateutil
    flask
    httpretty
    jinja2
    pytz
    werkzeug
    requests
    six
    xmltodict
    mock
    pyaml
    backports_tempfile
    cookies
    jsondiff
    botocore
    docker
  ];

  checkInputs = [ boto3 nose sure freezegun ];

  checkPhase = "nosetests";

  # TODO: make this true; I think lots of the tests want network access but we can probably run the others
  doCheck = false;
}
