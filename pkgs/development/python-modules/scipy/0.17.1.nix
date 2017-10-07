{lib, fetchurl, python, buildPythonPackage, isPyPy, gfortran, nose, numpy}:

buildPythonPackage rec {
  pname = "scipy";
  version = "0.17.1";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/s/scipy/scipy-${version}.tar.gz";
    sha256 = "1b1qpfz2j2rvmlplsjbnznnxnqr9ckbmis506110ii1w07wd4k4w";
  };

  buildInputs = [ gfortran nose numpy.blas ];
  propagatedBuildInputs = [ numpy ];

  # Remove tests because of broken wrapper
  prePatch = ''
    rm scipy/linalg/tests/test_lapack.py
  '';

  preConfigure = ''
    sed -i '0,/from numpy.distutils.core/s//import setuptools;from numpy.distutils.core/' setup.py
    export NPY_NUM_BUILD_JOBS=$NIX_BUILD_CORES
  '';

  preBuild = ''
    echo "Creating site.cfg file..."
    cat << EOF > site.cfg
    [openblas]
    include_dirs = ${numpy.blas}/include
    library_dirs = ${numpy.blas}/lib
    EOF
  '';

  enableParallelBuilding = true;

  checkPhase = ''
    runHook preCheck
    pushd dist
    ${python.interpreter} -c 'import scipy; scipy.test("fast", verbose=10)'
    popd
    runHook postCheck
  '';

  passthru = {
    blas = numpy.blas;
  };

  setupPyBuildFlags = [ "--fcompiler='gnu95'" ];

  meta = {
    description = "SciPy (pronounced 'Sigh Pie') is open-source software for mathematics, science, and engineering. ";
    homepage = http://www.scipy.org/;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
