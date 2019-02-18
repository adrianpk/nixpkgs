{ stdenv, fetchurl, gfortran, perl, libnl, rdma-core, zlib
, numactl

# Enable the Sun Grid Engine bindings
, enableSGE ? false

# Pass PATH/LD_LIBRARY_PATH to point to current mpirun by default
, enablePrefix ? false
}:

let
  version = "3.1.3";

in stdenv.mkDerivation rec {
  name = "openmpi-${version}";

  src = with stdenv.lib.versions; fetchurl {
    url = "http://www.open-mpi.org/software/ompi/v${major version}.${minor version}/downloads/${name}.tar.bz2";
    sha256 = "1dks11scivgaskjs5955y9wprsl12wr3gn5r7wfl0l8gq03l7q4b";
  };

  postPatch = ''
    patchShebangs ./
  '';

  buildInputs = with stdenv; [ gfortran zlib ]
    ++ lib.optionals isLinux [ libnl numactl ]
    ++ lib.optional (isLinux || isFreeBSD) rdma-core;

  nativeBuildInputs = [ perl ];

  configureFlags = with stdenv; [ "--disable-mca-dso" ]
    ++ lib.optional isLinux  "--with-libnl=${libnl.dev}"
    ++ lib.optional enableSGE "--with-sge"
    ++ lib.optional enablePrefix "--enable-mpirun-prefix-by-default"
    ;

  enableParallelBuilding = true;

  postInstall = ''
    rm -f $out/lib/*.la
   '';

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = http://www.open-mpi.org/;
    description = "Open source MPI-3 implementation";
    longDescription = "The Open MPI Project is an open source MPI-3 implementation that is developed and maintained by a consortium of academic, research, and industry partners. Open MPI is therefore able to combine the expertise, technologies, and resources from all across the High Performance Computing community in order to build the best MPI library available. Open MPI offers advantages for system and software vendors, application developers and computer science researchers.";
    maintainers = with maintainers; [ markuskowa ];
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
