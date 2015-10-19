
{ stdenv
, fetchurl
, cpp ? false
, gfortran ? null
, zlib ? null
, szip ? null
, mpi ? null
, enableShared ? true
}:
stdenv.mkDerivation rec {
  version = "1.8.15-patch1";
  name = "hdf5-${version}";
  src = fetchurl {
    url = "http://www.hdfgroup.org/ftp/HDF5/releases/hdf5-${version}/src/hdf5-${version}.tar.gz";
    sha256 = "19k39da6zzxyr0fnffn4iqlls9v1fsih877rznq8ypqy8mzf5dci";
 };

  passthru = {
    mpiSupport = (mpi != null);
    inherit mpi;
  };

  buildInputs = []
    ++ stdenv.lib.optional (gfortran != null) gfortran
    ++ stdenv.lib.optional (zlib != null) zlib
    ++ stdenv.lib.optional (szip != null) szip;

  propagatedBuildInputs = []
    ++ stdenv.lib.optional (mpi != null) mpi;

  configureFlags = "
    ${if cpp then "--enable-cxx" else ""}
    ${if gfortran != null then "--enable-fortran" else ""}
    ${if szip != null then "--with-szlib=${szip}" else ""}
    ${if mpi != null then "--enable-parallel" else ""}
    ${if enableShared then "--enable-shared" else ""}
  ";
  
  patches = [./bin-mv.patch];
  
  meta = {
    description = "Data model, library, and file format for storing and managing data";
    longDescription = ''
      HDF5 supports an unlimited variety of datatypes, and is designed for flexible and efficient
      I/O and for high volume and complex data. HDF5 is portable and is extensible, allowing 
      applications to evolve in their use of HDF5. The HDF5 Technology suite includes tools and 
      applications for managing, manipulating, viewing, and analyzing data in the HDF5 format.
    '';
    homepage = http://www.hdfgroup.org/HDF5/;
  };
}
