{ stdenv, buildPythonPackage, fetchPypi
, pytest, setuptools-git, pytest-shutil, pytest-fixture-config, psutil
, requests, future }:

buildPythonPackage rec {
  pname = "pytest-server-fixtures";
  version = "1.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c89f9532f62cf851489082ece1ec692b6ed5b0f88f20823bea25e2a963ebee8f";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ setuptools-git pytest-shutil pytest-fixture-config psutil requests future ];

  # RuntimeError: Unable to find a free server number to start Xvfb
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Extensible server fixures for py.test";
    homepage  = "https://github.com/manahl/pytest-plugins";
    license = licenses.mit;
    maintainers = with maintainers; [ nand0p ];
  };
}
