{ lib
, pythonPackages
, fetchurl
, transmission
, deluge
, config
}:

with pythonPackages;

buildPythonPackage rec {
  version = "2.8.17";
  name = "FlexGet-${version}";

  src = fetchurl {
    url = "https://github.com/Flexget/Flexget/archive/${version}.tar.gz";
    sha256 = "925e6bf62dfae73194dbf8b963ff2b60fb500f2457463b744086706da94dabd7";
  };

  # Requires vcrpy
  doCheck = false;
  checkPhase = ''
    py.test
  '';

  buildInputs = [ pytest mock ];
  propagatedBuildInputs = [
    feedparser sqlalchemy pyyaml
    beautifulsoup4 html5lib pyrss2gen pynzb
    rpyc jinja2 requests2 dateutil jsonschema
    pathpy pathlib guessit apscheduler
    terminaltables colorclass
    cherrypy flask flask-restful flask-restplus
    flask-compress flask_login flask-cors
    pyparsing safe future ]
  # enable deluge and transmission plugin support, if they're installed
  ++ lib.optional (config.deluge or false) deluge
  ++ lib.optional (transmission != null) transmissionrpc;

  meta = {
    homepage = http://flexget.com/;
    description = "Multipurpose automation tool for content like torrents";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ domenkozar tari ];
  };
}
