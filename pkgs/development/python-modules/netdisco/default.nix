{ stdenv, buildPythonPackage, isPy3k, fetchFromGitHub, requests, zeroconf, netifaces, pytest }:

buildPythonPackage rec {
  pname = "netdisco";
  version = "1.2.3";

  disabled = !isPy3k;

  # PyPI is missing tests/ directory
  src = fetchFromGitHub {
    owner = "home-assistant";
    repo = pname;
    rev = version;
    sha256 = "137p7qlv85mva96v6kav8xxca7i09k4giayag4cglrgjd7q3lk1r";
  };

  propagatedBuildInputs = [ requests zeroconf netifaces ];

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "Python library to scan local network for services and devices";
    homepage = https://github.com/home-assistant/netdisco/;
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dotlambda ];
  };
}
