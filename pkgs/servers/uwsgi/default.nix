{ stdenv, lib, fetchurl, pkgconfig, jansson
# plugins: list of strings, eg. [ "python2" "python3" ]
, plugins
, pam, withPAM ? false
, systemd, withSystemd ? false
, python2, python3, ncurses
, ruby, php-embed
}:

let pythonPlugin = pkg : lib.nameValuePair "python${if pkg ? isPy2 then "2" else "3"}" {
                           interpreter = pkg.interpreter;
                           path = "plugins/python";
                           inputs = [ pkg ncurses ];
                           install = ''
                             install -Dm644 uwsgidecorators.py $out/${pkg.sitePackages}/uwsgidecorators.py
                             ${pkg.executable} -m compileall $out/${pkg.sitePackages}/
                             ${pkg.executable} -O -m compileall $out/${pkg.sitePackages}/
                           '';
                         };

    available = lib.listToAttrs [
                  (pythonPlugin python2)
                  (pythonPlugin python3)
                  (lib.nameValuePair "rack" {
                    path = "plugins/rack";
                    inputs = [ ruby ];
                  })
                  (lib.nameValuePair "cgi" {
                    # usage: https://uwsgi-docs.readthedocs.io/en/latest/CGI.html?highlight=cgi
                    path = "plugins/cgi";
                    inputs = [ ];
                  })
                  (lib.nameValuePair "php" {
                    # usage: https://uwsgi-docs.readthedocs.io/en/latest/PHP.html#running-php-apps-with-nginx
                    path = "plugins/php";
                    preBuild = "touch unix.h";
                    inputs = [ php-embed ] ++ php-embed.buildInputs;
                  })
                ];

    getPlugin = name:
      let all = lib.concatStringsSep ", " (lib.attrNames available);
      in if lib.hasAttr name available
         then lib.getAttr name available // { inherit name; }
         else throw "Unknown UWSGI plugin ${name}, available : ${all}";

    needed = builtins.map getPlugin plugins;
in

stdenv.mkDerivation rec {
  name = "uwsgi-${version}";
  version = "2.0.15";

  src = fetchurl {
    url = "http://projects.unbit.it/downloads/${name}.tar.gz";
    sha256 = "1zvj28wp3c1hacpd4c6ra5ilwvvfq3l8y6gn8i7mnncpddlzjbjp";
  };

  nativeBuildInputs = [ python3 pkgconfig ];

  buildInputs =  [ jansson ]
              ++ lib.optional withPAM pam
              ++ lib.optional withSystemd systemd
              ++ lib.concatMap (x: x.inputs) needed
              ;

  basePlugins =  lib.concatStringsSep ","
                 (  lib.optional withPAM "pam"
                 ++ lib.optional withSystemd "systemd_logger"
                 );

  passthru = {
    inherit python2 python3;
  };

  configurePhase = ''
    export pluginDir=$out/lib/uwsgi
    substituteAll ${./nixos.ini} buildconf/nixos.ini
  '';

  buildPhase = ''
    mkdir -p $pluginDir
    python3 uwsgiconfig.py --build nixos
    ${lib.concatMapStringsSep ";" (x: "${x.preBuild or ""}\n ${x.interpreter or "python3"} uwsgiconfig.py --plugin ${x.path} nixos ${x.name}") needed}
  '';

  installPhase = ''
    install -Dm755 uwsgi $out/bin/uwsgi
    ${lib.concatMapStringsSep "\n" (x: x.install or "") needed}
  '';

  NIX_CFLAGS_LINK = [ "-lsystemd" ];

  meta = with stdenv.lib; {
    homepage = http://uwsgi-docs.readthedocs.org/en/latest/;
    description = "A fast, self-healing and developer/sysadmin-friendly application container server coded in pure C";
    license = licenses.gpl2;
    maintainers = with maintainers; [ abbradar schneefux ];
    platforms = platforms.linux;
  };
}
