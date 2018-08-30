{ lib, buildPythonPackage, fetchPypi
, pytest, pytestrunner, pytestcov, mock, glibcLocales, lxml, boto3, requests, click, configparser }:

buildPythonPackage rec {
  version = "0.12.0";
  pname = "aws-adfs";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1cjrm61k6905dmhgrqyc5caxx5hbhj3sr6cx4r6sbdyz453i7pc6";
  };

  # Relax version constraint
  patchPhase = ''
    sed -i 's/coverage < 4/coverage/' setup.py
  '';

  # Test suite writes files to $HOME/.aws/, or /homeless-shelter if unset
  HOME = ".";

  # Required for python3 tests, along with glibcLocales
  LC_ALL = "en_US.UTF-8";

  checkInputs = [ glibcLocales pytest pytestrunner pytestcov mock ];
  propagatedBuildInputs = [ lxml boto3 requests click configparser ];

  meta = {
    description = "Command line tool to ease aws cli authentication against ADFS";
    homepage = https://github.com/venth/aws-adfs;
    license = lib.licenses.psfl;
    maintainers = [ lib.maintainers.bhipple ];
  };
}
