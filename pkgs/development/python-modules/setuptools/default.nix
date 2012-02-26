{ stdenv, fetchurl, python, wrapPython, site }:

stdenv.mkDerivation rec {
  name = "setuptools-0.6c11";

  src = fetchurl {
    url = "http://pypi.python.org/packages/source/s/setuptools/${name}.tar.gz";
    sha256 = "1lx1hwxkhipyh206bgl90ddnfcnb68bzcvyawczbf833fadyl3v3";
  };

  buildInputs = [ python wrapPython site ];

  buildPhase = "python setup.py build --build-base $out";

  installPhase =
    ''
      dst=$out/lib/${python.libPrefix}/site-packages
      mkdir -p $dst
      PYTHONPATH=$dst:$PYTHONPATH
      python setup.py install --prefix=$out
      # remove generic files, leave setuptools.pth
      rm $dst/site.py*
      rm $dst/easy-install.pth
      pythonPath=${site} wrapPythonPrograms
    '';

  doCheck = false; # doesn't work with Python 2.7

  checkPhase = "python setup.py test";

  meta = {
    description = "Utilities to facilitate the installation of Python packages";
    homepage = http://pypi.python.org/pypi/setuptools;
    licenses = [ "PSF" "ZPL" ];
  };    
}
