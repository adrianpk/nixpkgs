{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.mysql;

  mysql = cfg.package;

  pidFile = "${cfg.pidDir}/mysqld.pid";

  mysqldOptions =
    "--user=${cfg.user} --datadir=${cfg.dataDir} " +
    "--log-error=${cfg.logError} --pid-file=${pidFile}";

in

{

  ###### interface

  options = {
  
    services.mysql = {
    
      enable = mkOption {
        default = false;
        description = "
          Whether to enable the MySQL server.
        ";
      };

      package = mkOption {
        default = pkgs.mysql;
        description = "
          Which MySQL derivation to use.
        ";
      };

      port = mkOption {
        default = "3306";
        description = "Port of MySQL"; 
      };

      user = mkOption {
        default = "mysql";
        description = "User account under which MySQL runs";
      };

      dataDir = mkOption {
        default = "/var/mysql"; # !!! should be /var/db/mysql
        description = "Location where MySQL stores its table files";
      };

      logError = mkOption {
        default = "/var/log/mysql_err.log";
        description = "Location of the MySQL error logfile";
      };

      pidDir = mkOption {
        default = "/var/run/mysql";
        description = "Location of the file which stores the PID of the MySQL server";
      };
      
      initialDatabases = mkOption {
        default = [];
        description = "List of database names and their initial schemas that should be used to create databases on the first startup of MySQL";
	example = [
	  { name = "foodatabase"; schema = ./foodatabase.sql; }
	  { name = "bardatabase"; schema = ./bardatabase.sql; }
	];
      };
    };
    
  };


  ###### implementation

  config = mkIf config.services.mysql.enable {

    users.extraUsers = singleton
      { name = "mysql";
        description = "MySQL server user";
      };

    environment.systemPackages = [mysql];

    jobs.mysql =
      { description = "MySQL server";

        startOn = "started network-interfaces";

        preStart =
          ''
            if ! test -e ${cfg.dataDir}/mysql; then
                mkdir -m 0700 -p ${cfg.dataDir}
                chown -R ${cfg.user} ${cfg.dataDir}
                ${mysql}/bin/mysql_install_db ${mysqldOptions}
            fi

            mkdir -m 0700 -p ${cfg.pidDir}
            chown -R ${cfg.user} ${cfg.pidDir}
          '';

        exec = "${mysql}/libexec/mysqld ${mysqldOptions}";
	
	postStart =
	  ''
            # Wait until the MySQL server is available for use
            count=0
            while [ ! -e /tmp/mysql.sock ]
            do
                if [ $count -eq 30 ]
                then
                  echo "Tried 30 times, giving up..."
	          exit 1
                 fi

                 echo "MySQL daemon not yet started. Waiting for 1 second..."
                 count=$((count++))
                 sleep 1
            done

            # Create initial databases

            ${concatMapStrings (database: 
              ''
                if ! test -e "${cfg.dataDir}/${database.name}"; then
                    echo "Creating initial database: ${database.name}"
                    ( echo "create database ${database.name};"
                      echo "use ${database.name};"
		      if [ -f "${database.schema}" ]
		      then
                          cat ${database.schema}
		      elif [ -d "${database.schema}" ]
		      then
		          cat ${database.schema}/mysql-databases/*.sql
		      fi
		    ) | ${mysql}/bin/mysql -u root -N
                fi
              '') cfg.initialDatabases}            
	  '';

        # !!! Need a postStart script to wait until mysqld is ready to
        # accept connections.

        extraConfig = "kill timeout 60";
      };

  };

}
