{ pkgs, fetchurl, buildPythonPackage, pythonPackages }:

buildPythonPackage rec {
  version = "1.8.1-beta";
  name = "gmvault-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/gaubert/gmvault-official-download/downloads/gmvault-v${version}-src.tar.gz";
    name = "${name}.tar.bz";
    sha256 = "0b575cnrd6jzcpa05mbn2swzcy0r9ck09pkhs4ydj6d3ir52j80c";
  };

  doCheck = false;

  propagatedBuildInputs = [
    pythonPackages.gdata
    pythonPackages.IMAPClient
    pythonPackages.Logbook
    pythonPackages.argparse
  ];

  startScript = ./gmvault.py;

  patchPhase = ''
    cat ${startScript} > etc/scripts/gmvault
    chmod +x etc/scripts/gmvault
  '';

  meta = {
    description = "Gmvault Gmail Backup - Backup and restore your gmail account at will.";
    homepage = "http://gmvault.org";
    license = pkgs.lib.licenses.agpl3Plus;
  };
}
