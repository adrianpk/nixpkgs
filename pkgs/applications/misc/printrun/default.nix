{ stdenv, python27Packages, fetchFromGitHub }:

python27Packages.buildPythonPackage rec {
  name = "printrun-20150310";

  src = fetchFromGitHub {
    owner = "kliment";
    repo = "Printrun";
    rev = name;
    sha256 = "09ijv8h4k5h15swg64s7igamvynawz7gdi7hiymzrzywdvr0zwsa";
  };

  propagatedBuildInputs = with python27Packages; [
    wxPython30 pyserial dbus psutil numpy pyopengl pyglet cython
  ];

  doCheck = false;

  postPatch = ''
    sed -i -r "s|/usr(/local)?/share/|$out/share/|g" printrun/utils.py
    sed -i "s|distutils.core|setuptools|" setup.py
    sed -i "s|distutils.command.install |setuptools.command.install |" setup.py
  '';

  postInstall = ''
    for f in $out/share/applications/*.desktop; do
      sed -i -e "s|/usr/|$out/|g" "$f"
    done
  '';

  meta = with stdenv.lib; {
    description = "Pronterface, Pronsole, and Printcore - Pure Python 3d printing host software";
    homepage = https://github.com/kliment/Printrun;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
