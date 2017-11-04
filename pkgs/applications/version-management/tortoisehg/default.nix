{lib, fetchurl, mercurial, python2Packages}:

python2Packages.buildPythonApplication rec {
    name = "tortoisehg-${version}";
    version = "4.3.1";

    src = fetchurl {
      url = "https://bitbucket.org/tortoisehg/targz/downloads/${name}.tar.gz";
      sha256 = "0lxppjdqjmwl5y8fmp2am0my7a3mks811yg4fff7cx0569hdp62n";
    };

    pythonPath = with python2Packages; [ pyqt4 mercurial qscintilla iniparse ];

    propagatedBuildInputs = with python2Packages; [ qscintilla iniparse ];

    doCheck = false;
    dontStrip = true;
    buildPhase = "";
    installPhase = ''
      ${python2Packages.python.executable} setup.py install --prefix=$out
      ln -s $out/bin/thg $out/bin/tortoisehg     #convenient alias
    '';

    meta = {
      description = "Qt based graphical tool for working with Mercurial";
      homepage = http://tortoisehg.bitbucket.org/;
      license = lib.licenses.gpl2;
      platforms = lib.platforms.linux;
      maintainers = with lib.maintainers; [ danbst ];
    };
}
