# Management of static files in /etc.

{ config, pkgs, ... }:

with pkgs.lib;

let

  etc' = attrValues config.environment.etc;

  etc = pkgs.stdenv.mkDerivation {
    name = "etc";

    builder = ./make-etc.sh;

    preferLocalBuild = true;

    /* !!! Use toXML. */
    sources = map (x: x.source) etc';
    targets = map (x: x.target) etc';
    modes = map (x: x.mode) etc';
  };

in

{

  ###### interface

  options = {

    environment.etc = mkOption {
      type = types.loaOf types.optionSet;
      default = {};
      example =
        { hosts =
            { source = "/nix/store/.../etc/dir/file.conf.example";
              mode = "0440";
            };
          "default/useradd".text = "GROUP=100 ...";
        };
      description = ''
        Set of files that have to be linked in <filename>/etc</filename>.
      '';

      options = singleton ({ name, config, ... }:
        { options = {
            source = mkOption {
              description = "Path of the source file.";
            };

            target = mkOption {
              description = ''
                Name of symlink (relative to
                <filename>/etc</filename>).  Defaults to the attribute
                name.
              '';
            };

            mode = mkOption {
              default = "symlink";
              example = "0600";
              description = ''
                If set to something else than <literal>symlink</literal>,
                the file is copied instead of symlinked, with the given
                file mode.
              '';
            };

          };

          config = {
            target = mkDefault name;
          };

        });

    };

  };


  ###### implementation

  config = {

    system.build.etc = etc;

    system.activationScripts.etc = stringAfter [ "stdio" ]
      ''
        # Set up the statically computed bits of /etc.
        echo "setting up /etc..."
        ${pkgs.perl}/bin/perl ${./setup-etc.pl} ${etc}/etc
      '';

  };

}
