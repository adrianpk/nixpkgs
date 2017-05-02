{ stdenv, buildPythonPackage, fetchurl, python,
  zope_interface, incremental, automat, constantly
}:
buildPythonPackage rec {

  name = "Twisted-${version}";
  version = "17.1.0";

  src = fetchurl {
    url = "mirror://pypi/T/Twisted/${name}.tar.bz2";
    sha256 = "1p245mg15hkxp7hy5cyq2fgvlgjkb4cg0gwkwd148nzy1bbi3wnv";
  };

  propagatedBuildInputs = [ zope_interface incremental automat constantly ];

  # Patch t.p._inotify to point to libc. Without this,
  # twisted.python.runtime.platform.supportsINotify() == False
  patchPhase = stdenv.lib.optionalString stdenv.isLinux ''
    substituteInPlace src/twisted/python/_inotify.py --replace \
      "ctypes.util.find_library('c')" "'${stdenv.glibc.out}/lib/libc.so.6'"
  '';

  # Generate Twisted's plug-in cache.  Twisted users must do it as well.  See
  # http://twistedmatrix.com/documents/current/core/howto/plugin.html#auto3
  # and http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=477103 for
  # details.
  postInstall = "$out/bin/twistd --help > /dev/null";

  checkPhase = ''
    ${python.interpreter} -m unittest discover -s twisted/test
  '';
  # Tests require network
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://twistedmatrix.com/;
    description = "Twisted, an event-driven networking engine written in Python";
    longDescription = ''
      Twisted is an event-driven networking engine written in Python
      and licensed under the MIT license.
    '';
    license = licenses.mit;
    maintainers = [ ];
  };
}
