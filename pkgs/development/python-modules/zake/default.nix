{ stdenv
, buildPythonPackage
, fetchPypi
, kazoo
, six
, testtools
, python
}:

buildPythonPackage rec {
  pname = "zake";
  version = "0.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rp4xxy7qp0s0wnq3ig4ji8xsl31g901qkdp339ndxn466cqal2s";
  };

  propagatedBuildInputs = [ kazoo six ];
  buildInputs = [ testtools ];
  checkPhase = ''
    ${python.interpreter} -m unittest discover zake/tests
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/yahoo/Zake";
    description = "A python package that works to provide a nice set of testing utilities for the kazoo library";
    license = licenses.asl20;
  };

}
