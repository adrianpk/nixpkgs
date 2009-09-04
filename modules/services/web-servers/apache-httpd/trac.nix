{ config, pkgs, serverInfo, ... }:

let
  inherit (pkgs.lib) mkOption;
  
  # Build a Subversion instance with Apache modules and Swig/Python bindings.
  subversion = pkgs.subversion.override (origArgs: {
    bdbSupport = true;
    httpServer = true;
    sslSupport = true;
    compressionSupport = true;
    pythonBindings = true;
  });
in
{
  options = {
    projectsLocation = mkOption {
      description = "URL path in which Trac projects can be accessed";
      default = "/projects";
    };
    
    projects = mkOption {
      description = "List of projects that should be provided by Trac. If they are not defined yet empty projects are created.";
      default = [];
      example = [ { identifier = "myproject";
                    name = "My Project";
                    databaseURL="postgres://root:password@/tracdb";
                    subversionRepository="/data/subversion/myproject"; } ];
    };
    
    user = mkOption {
      default = "wwwrun";
      description = "
        User account under which Trac runs.
      ";
    };

    group = mkOption {
      default = "wwwrun";
      description = "
        Group under which Trac runs.
      ";
    };
  };

  extraModules = [
    { name = "python"; path = "${pkgs.mod_python}/modules/mod_python.so"; }
  ];
  
  extraConfig = ''
    <Location ${config.projectsLocation}>
      SetHandler mod_python
      PythonHandler trac.web.modpython_frontend
      PythonOption TracEnvParentDir /var/trac/projects
      PythonOption TracUriRoot ${config.projectsLocation}
      PythonOption PYTHON_EGG_CACHE /var/trac/egg-cache
    </Location>
  '';
  
  globalEnvVars = [
    { name = "PYTHONPATH";
      value = 
        "${pkgs.mod_python}/lib/python2.5/site-packages:" +
	"${pkgs.pythonPackages.trac}/lib/python2.5/site-packages:" +
	"${pkgs.setuptools}/lib/python2.5/site-packages:" +
	"${pkgs.pythonPackages.genshi}/lib/python2.5/site-packages:" +
	"${pkgs.pythonPackages.psycopg2}/lib/python2.5/site-packages:" +
	"${subversion}/lib/python2.5/site-packages";
    }
  ];
  
  startupScript = pkgs.writeScript "activateTrac" ''
    mkdir -p /var/trac
    chown ${config.user}:${config.group} /var/trac
    
    ${pkgs.lib.concatMapStrings (project:
      ''
        if [ ! -d /var/trac/${project.identifier} ]
	then
	    export PYTHONPATH=${pkgs.pythonPackages.psycopg2}/lib/python2.5/site-packages
	    ${pkgs.pythonPackages.trac}/bin/trac-admin /var/trac/${project.identifier} initenv "${project.name}" "${project.databaseURL}" svn "${project.subversionRepository}"
	fi
      '' ) (config.projects)}
  '';
}
