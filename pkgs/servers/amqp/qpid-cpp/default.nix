{ stdenv, fetchurl, cmake, python2, boost, libuuid, ruby }:

stdenv.mkDerivation rec {
  name = "qpid-cpp-${version}";

  version = "1.37.0";

  src = fetchurl {
    url = "mirror://apache/qpid/cpp/${version}/${name}.tar.gz";
    sha256 = "1s4hyi867i0lqn81c1crrk6fga1gmsv61675vjv5v41skz56lrsb";
  };

  buildInputs = [ cmake python2 boost libuuid ruby ];

  # the subdir managementgen wants to install python stuff in ${python} and
  # the installation tries to create some folders in /var
  patchPhase = ''
    sed -i '/managementgen/d' CMakeLists.txt
    sed -i '/ENV/d' src/CMakeLists.txt
  '';

  NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations -Wno-error=unused-function";

  meta = {
    homepage = http://qpid.apache.org;
    repositories.git = git://git.apache.org/qpid.git;
    repositories.svn = http://svn.apache.org/repos/asf/qpid;
    description = "An AMQP message broker and a C++ messaging API";
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.cpages ];
  };
}
