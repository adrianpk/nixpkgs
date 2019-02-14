{ stdenv
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  version = "2.0.1";
  pname = "PasteDeploy";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d423fb9d51fdcf853aa4ff43ac7ec469b643ea19590f67488122d6d0d772350a";
  };

  buildInputs = [ nose ];

  meta = with stdenv.lib; {
    description = "Load, configure, and compose WSGI applications and servers";
    homepage = http://pythonpaste.org/deploy/;
    license = licenses.mit;
  };

}
