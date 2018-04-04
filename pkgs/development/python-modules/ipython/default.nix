{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
# Build dependencies
, glibcLocales
# Test dependencies
, nose
, pygments
# Runtime dependencies
, jedi
, decorator
, pickleshare
, simplegeneric
, traitlets
, prompt_toolkit
, pexpect
, appnope
, typing
, backcall
}:

buildPythonPackage rec {
  pname = "ipython";
  version = "6.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c785ab502b1a63624baeb89fedb873a118d4da6c9a796ae06e4f4aaef74e9ea0";
  };

  prePatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace setup.py --replace "'gnureadline'" " "
  '';

  buildInputs = [ glibcLocales ];

  checkInputs = [ nose pygments ];

  propagatedBuildInputs = [
    jedi
    decorator
    pickleshare
    simplegeneric
    traitlets
    prompt_toolkit
    pexpect
    backcall
  ] ++ lib.optionals stdenv.isDarwin [appnope]
    ++ lib.optionals (pythonOlder "3.5") [ typing ];

  LC_ALL="en_US.UTF-8";

  doCheck = false; # Circular dependency with ipykernel

  checkPhase = ''
    nosetests
  '';

  # IPython 6.0.0 and above does not support Python < 3.3.
  # The last IPython version to support older Python versions
  # is 5.3.x.
  disabled = pythonOlder "3.3";

  meta = {
    description = "IPython: Productive Interactive Computing";
    homepage = http://ipython.org/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bjornfor jgeerds fridh ];
  };
}
