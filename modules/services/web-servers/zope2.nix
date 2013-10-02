{ pkgs, config, ... }:

with pkgs.lib;

let

  cfg = config.services.zope2;

  zope2Opts = { name, config, ... }: {
    options = {

      name = mkOption {
        default = "${name}";
        type = types.string;
        description = "The name of the zope2 instance. If undefined, the name of the attribute set will be used.";
      };

      threads = mkOption {
        default = 2;
        type = types.int;
        description = "Specify the number of threads that Zope's ZServer web server will use to service requests. ";
      };

      http_address = mkOption {
        default = "localhost:8080";
        type = types.string;
        description = "Give a port and adress for the HTTP server.";
      };

      user = mkOption {
        default = "zope2";
        type = types.string;
        description = "The name of the effective user for the Zope process.";
      };

      extra = mkOption {
        default =
          ''
          <zodb_db main>
          mount-point /
          cache-size 30000
          <blobstorage>
              blob-dir /var/lib/zope2/${name}/blobstorage
              <filestorage>
              path /var/lib/zope2/${name}/filestorage/Data.fs
              </filestorage>
          </blobstorage>
          </zodb_db>
          '';
        type = types.string;
        description = "Extra zope.conf";
      };

      packages = mkOption {
        type = types.listOf types.package;
        description = "The list of packages you want to make available to the zope2 instance.";
      };

    };
  };

in

{

  ###### interface

  options = {

    services.zope2.instances = mkOption {
      default = {};
      type = types.loaOf types.optionSet;
      example = {
        plone01 = {
          http_address = "127.0.0.1:8080";
          extra =
            ''
            <zodb_db main>
            mount-point /
            cache-size 30000
            <blobstorage>
                blob-dir /var/lib/zope2/plone01/blobstorage
                <filestorage>
                path /var/lib/zope2/plone01/filestorage/Data.fs
                </filestorage>
            </blobstorage>
            </zodb_db>
            '';

        };
      };
      description = "zope2 instances to be created automaticaly by the system.";
      options = [ zope2Opts ];
    };
  };

  ###### implementation

  config = mkIf (cfg.instances != {}) {

    users.extraUsers.zope2.uid = config.ids.uids.zope2;

    systemd.services =
      let

        createZope2Instance = opts: name:
          let
            interpreter = pkgs.writeScript "interpreter"
              ''
import sys

_interactive = True
if len(sys.argv) > 1:
    _options, _args = __import__("getopt").getopt(sys.argv[1:], 'ic:m:')
    _interactive = False
    for (_opt, _val) in _options:
        if _opt == '-i':
            _interactive = True
        elif _opt == '-c':
            exec _val
        elif _opt == '-m':
            sys.argv[1:] = _args
            _args = []
            __import__("runpy").run_module(
                 _val, {}, "__main__", alter_sys=True)

    if _args:
        sys.argv[:] = _args
        __file__ = _args[0]
        del _options, _args
        execfile(__file__)

if _interactive:
    del _interactive
    __import__("code").interact(banner="", local=globals())
              '';
            env = pkgs.buildEnv {
              name = "zope2-${name}-env";
              paths = [ pyenv pkgs.gnumake ];
              postBuild =
                ''
                echo "#!$out/bin/python" > $out/bin/interpreter
                cat ${interpreter} >> $out/bin/interpreter
                '';
            };
            pyenv = pkgs.buildEnv {
              name = "zope2-${name}-pyenv";
              paths = [
                pkgs.python27
                pkgs.python27Packages.recursivePthLoader
                pkgs.python27Packages."plone.recipe.zope2instance"
              ] ++ attrValues pkgs.python27.modules
                ++ opts.packages;
            };
            conf = pkgs.writeText "zope2-${name}-conf"
              ''%define INSTANCEHOME ${env}
instancehome $INSTANCEHOME
%define CLIENTHOME /var/lib/zope2/${name}
clienthome $CLIENTHOME

debug-mode off
security-policy-implementation C
verbose-security off
default-zpublisher-encoding utf-8
zserver-threads ${toString opts.threads}
effective-user ${opts.user}

pid-filename /var/run/zope2-${name}.pid
lock-filename /var/lock/zope2-${name}.lock
python-check-interval 1000
enable-product-installation off

<environment>
  zope_i18n_compile_mo_files false
</environment>

<eventlog>
level INFO
<logfile>
    path /var/log/zope2/${name}.log
    level INFO
</logfile>
</eventlog>

<logger access>
level WARN
<logfile>
    path /var/log/zope2/${name}-Z2.log
    format %(message)s
</logfile>
</logger>

<http-server>
address ${opts.http_address}
</http-server>

<zodb_db temporary>
<temporarystorage>
    name temporary storage for sessioning
</temporarystorage>
mount-point /temp_folder
container-class Products.TemporaryFolder.TemporaryContainer
</zodb_db>

${opts.extra}
              '';
            ctl = pkgs.writeScript "zope2-${name}-ctl"
              ''#!${env}/bin/python

import sys
import plone.recipe.zope2instance.ctl

if __name__ == '__main__':
    sys.exit(plone.recipe.zope2instance.ctl.main(
        ["-C", "${conf}"]
        + sys.argv[1:]))'';
          in {
            description = "zope2 ${name} instance";
            after = [ "network.target" ];  # with RelStorage also add "postgresql.service"
            wantedBy = [ "multi-user.target" ];
            path = opts.packages;
            preStart =
              ''
              mkdir -p /var/log/zope2/
              mkdir -p /var/lib/zope2/${name}/filestorage /var/lib/zope2/${name}/blobstorage
              chown ${opts.user} /var/lib/zope2/${name} -R

              ${ctl} adduser admin admin
              '';

            serviceConfig.Type = "forking";
            serviceConfig.ExecStart = "${ctl} start";
            serviceConfig.ExecStop = "${ctl} stop";
            serviceConfig.ExecReload = "${ctl} restart";
          };

      in listToAttrs (map (name: { name = "zope2-${name}"; value = createZope2Instance (builtins.getAttr name cfg.instances) name; }) (builtins.attrNames cfg.instances));

  };

}
