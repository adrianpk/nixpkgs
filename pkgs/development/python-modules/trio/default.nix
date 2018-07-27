{ lib, buildPythonPackage, fetchPypi, pythonOlder
, attrs
, sortedcontainers
, async_generator
, idna
, outcome
, contextvars
, pytest
, pyopenssl
, trustme
}:

buildPythonPackage rec {
  pname = "trio";
  version = "0.5.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ce0b4f59e2f41af0433247f92ce83116bf356a3c2ab5ca5942cf359a1105b4a8";
  };

  checkInputs = [ pytest pyopenssl trustme ];
  # It appears that the build sandbox doesn't include /etc/services, and these tests try to use it.
  checkPhase = ''
    py.test -k 'not test_getnameinfo and not test_SocketType_resolve and not test_getprotobyname'
  '';
  propagatedBuildInputs = [
    attrs
    sortedcontainers
    async_generator
    idna
    outcome
  ] ++ lib.optionals (pythonOlder "3.7") [ contextvars ];

  meta = {
    description = "An async/await-native I/O library for humans and snake people";
    homepage = https://github.com/python-trio/trio;
    license = with lib.licenses; [ mit asl20 ];
    maintainers = with lib.maintainers; [ catern ];
  };
}
