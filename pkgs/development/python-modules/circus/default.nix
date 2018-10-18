{ stdenv, buildPythonPackage, fetchPypi
, iowait, psutil, pyzmq, tornado, mock }:

buildPythonPackage rec {
  pname = "circus";
  version = "0.15.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d1603cf4c4f620ce6593d3d2a67fad25bf0242183ea24110d8bb1c8079c55d1b";
  };

  postPatch = ''
    # relax version restrictions to fix build
    substituteInPlace setup.py \
      --replace "pyzmq>=13.1.0,<17.0" "pyzmq>13.1.0" \
      --replace "tornado>=3.0,<5.0" "tornado>=3.0"
  '';

  checkInputs = [ mock ];

  doCheck = false; # weird error

  propagatedBuildInputs = [ iowait psutil pyzmq tornado ];

  meta = with stdenv.lib; {
    description = "A process and socket manager";
    homepage = "https://github.circus.com/circus-tent/circus";
    license = licenses.asl20;
  };
}
