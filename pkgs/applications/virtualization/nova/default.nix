{ stdenv, fetchurl, pythonPackages, intltool, libvirt, libxml2Python }:

with stdenv.lib;

let version = "2011.1.1"; in

stdenv.mkDerivation rec {
  name = "nova-${version}";

  src = fetchurl {
    url = "http://launchpad.net/nova/bexar/${version}/+download/nova-${version}.tar.gz";
    sha256 = "0xd7cxn60vzhkvjwnj0i6jfcxaggwwyw2pnhl4qnb759q9hvk1b9";
  };

  pythonPath = with pythonPackages;
    [ setuptools eventlet greenlet gflags netaddr sqlalchemy carrot routes
      paste_deploy m2crypto ipy boto_1_9 twisted sqlalchemy_migrate
      distutils_extra simplejson readline glance cheetah
      # !!! should libvirt be a build-time dependency?  Note that
      # libxml2Python is a dependency of libvirt.py. 
      libvirt libxml2Python 
    ];

  buildInputs =
    [ pythonPackages.python 
      pythonPackages.wrapPython
      pythonPackages.mox
      intltool
    ] ++ pythonPath;

  PYTHON_EGG_CACHE = "`pwd`/.egg-cache";

  preConfigure =
    ''
      # Set the built-in state location to something sensible.
      sed -i nova/flags.py \
        -e "/DEFINE.*'state_path'/ s|../|/var/lib/nova|"
    '';
  
  buildPhase = "python setup.py build";

  installPhase =
    ''    
      p=$(toPythonPath $out)
      export PYTHONPATH=$p:$PYTHONPATH
      mkdir -p $p
      python setup.py install --prefix=$out

      # Nova doesn't like to be called ".nova-foo-wrapped" because it
      # computes some stuff from its own argv[0].  So call the wrapped
      # programs ".nova-foo" by overriding wrapProgram.
      wrapProgram() {
          local prog="$1"
          local hidden="$(dirname "$prog")/.$(basename "$prog")"
          mv $prog $hidden
          makeWrapper $hidden $prog "$@"
      }
      
      wrapPythonPrograms

      mkdir -p $out/etc
      cp etc/nova-api.conf $out/etc/
    '';

  doCheck = false; # !!! fix

  checkPhase = "python setup.py test";
    
  meta = {
    homepage = http://nova.openstack.org/;
    description = "OpenStack Compute (a.k.a. Nova), a cloud computing fabric controller";
  };
}
