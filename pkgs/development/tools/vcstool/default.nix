{ stdenv, python3Packages
, git, bazaar, subversion }:

with python3Packages;

buildPythonApplication rec {
  name = "${pname}-${version}";
  pname = "vcstool";
  version = "0.1.32";

  src = fetchPypi {
    inherit pname version;
    sha256 = "adf09fad9feaa9bc2d7fe53e909951b6b7300db2f2e0717f12ccd44e047a8839";
  };

  propagatedBuildInputs = [ pyyaml ];

  makeWrapperArgs = ["--prefix" "PATH" ":" "${stdenv.lib.makeBinPath [ git bazaar subversion ]}"];

  doCheck = false; # requires network

  meta = with stdenv.lib; {
    description = "Provides a command line tool to invoke vcs commands on multiple repositories";
    homepage = https://github.com/dirk-thomas/vcstool;
    license = licenses.asl20;
    maintainers = with maintainers; [ sivteck ];
  };
}
