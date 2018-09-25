{ buildPythonPackage, isPy3k, fetchPypi, stdenv, exiv2, boost, libcxx, substituteAll, python }:

buildPythonPackage rec {
  pname = "py3exiv2";
  version = "0.4.0";
  disabled = !(isPy3k);

  src = fetchPypi {
    inherit pname version;
    sha256 = "4042492db49efbdfc53e0afa89509695826b3fb74fb52444ed04f64c229a65f5";
  };

  buildInputs = [ exiv2 boost ];

  # work around python distutils compiling C++ with $CC (see issue #26709)
  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin "-I${libcxx}/include/c++/v1";

  # fix broken libboost_python3 detection
  patches = [
    (substituteAll {
      src = ./setup.patch;
      version = "3${stdenv.lib.versions.minor python.version}";
    })
  ];

  meta = {
    homepage = "https://launchpad.net/py3exiv2";
    description = "A Python3 binding to the library exiv2";
    license = with stdenv.lib.licenses; [ gpl3 ];
    maintainers = with stdenv.lib.maintainers; [ vinymeuh ];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
