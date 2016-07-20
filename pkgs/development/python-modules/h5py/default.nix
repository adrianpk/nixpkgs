{ stdenv, fetchurl, python, buildPythonPackage
, numpy, hdf5, cython, six, pkgconfig
, mpi4py ? null }:

assert hdf5.mpiSupport -> mpi4py != null && hdf5.mpi == mpi4py.mpi;

with stdenv.lib;

let
  mpi = hdf5.mpi;
  mpiSupport = hdf5.mpiSupport;

in buildPythonPackage rec {
  name = "h5py-${version}";
  version = "2.5.0";

  src = fetchurl {
    url = "mirror://pypi/h/h5py/${name}.tar.gz";
    sha256 = "9833df8a679e108b561670b245bcf9f3a827b10ccb3a5fa1341523852cfac2f6";
  };

  configure_flags = "--hdf5=${hdf5}" + optionalString mpiSupport " --mpi";

  postConfigure = ''
    ${python.executable} setup.py configure ${configure_flags}
  '';

  preBuild = if mpiSupport then "export CC=${mpi}/bin/mpicc" else "";

  buildInputs = [ hdf5 cython pkgconfig ]
    ++ optional mpiSupport mpi
    ;
  propagatedBuildInputs = [ numpy six]
    ++ optional mpiSupport mpi4py
    ;

  meta = {
    description =
      "Pythonic interface to the HDF5 binary data format";
    homepage = "http://www.h5py.org/";
    license = stdenv.lib.licenses.bsd2;
  };
}
