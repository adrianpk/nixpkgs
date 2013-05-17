{pkgs, config, ...}:

with pkgs.lib;

let

  ids = config.ids;
  cfg = config.users;

  userOpts = { name, config, ... }: {

    options = {

      name = mkOption {
        type = types.str;
        description = "The name of the user account. If undefined, the name of the attribute set will be used.";
      };

      description = mkOption {
        type = types.str;
        default = "";
        example = "Alice Q. User";
        description = ''
          A short description of the user account, typically the
          user's full name.  This is actually the “GECOS” or “comment”
          field in <filename>/etc/passwd</filename>.
        '';
      };

      uid = mkOption {
        type = with types; uniq int;
        description = "The account UID.";
      };

      group = mkOption {
        type = types.str;
        default = "nogroup";
        description = "The user's primary group.";
      };

      extraGroups = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "The user's auxiliary groups.";
      };

      home = mkOption {
        type = types.str;
        default = "/var/empty";
        description = "The user's home directory.";
      };

      shell = mkOption {
        type = types.str;
        default = "/run/current-system/sw/sbin/nologin";
        description = "The path to the user's shell.";
      };

      createHome = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If true, the home directory will be created automatically. If this
          option is true and the home directory already exists but is not
          owned by the user, directory owner and group will be changed to
          match the user.
        '';
      };

      useDefaultShell = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If true, the user's shell will be set to
          <literal>cfg.defaultUserShell</literal>.
        '';
      };

      password = mkOption {
        type = with types; uniq (nullOr str);
        default = null;
        description = ''
          The user's password. If undefined, no password is set for
          the user.  Warning: do not set confidential information here
          because it is world-readable in the Nix store.  This option
          should only be used for public accounts such as
          <literal>guest</literal>.
          The option <literal>password</literal> overrides
          <literal>passwordFile</literal>, if both are specified.
          If none of the options <literal>password</literal> or
          <literal>passwordFile</literal> are specified, the user account will
          be locked for password logins. This is the default behavior except
          for the root account, which has an empty password by default. If you
          want to lock the root account for password logins, set
          <literal>users.extraUsers.root.password</literal> to
          <literal>null</literal>.
        '';
      };

      passwordFile = mkOption {
        type = with types; uniq (nullOr string);
        default = null;
        description = ''
          The path to a file that contains the user's password. The password
          file is read on each system activation. The file should contain
          exactly one line, which should be the password in an encrypted form
          that is suitable for the <literal>chpasswd -e</literal> command.
          See the <literal>password</literal> for more details on how passwords
          are assigned.
        '';
      };

      createUser = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Indicates if the user should be created automatically as a local user.
          Set this to false if the user for instance is an LDAP user. NixOS will
          then not modify any of the basic properties for the user account.
        '';
      };
    };

    config = {
      name = mkDefault name;
      shell = mkIf config.useDefaultShell (mkDefault cfg.defaultUserShell);
    };

  };

  groupOpts = { name, config, ... }: {

    options = {

      name = mkOption {
        type = types.str;
        description = "The name of the group. If undefined, the name of the attribute set will be used.";
      };

      gid = mkOption {
        type = with types; uniq int;
        description = "The GID of the group.";
      };

      members = mkOption {
        type = with types; listOf string;
        default = [];
        description = ''
        '';
      };

    };

    config = {
      name = mkDefault name;
    };

  };

  getGroup = gname:
    let
      groups = mapAttrsToList (n: g: g) (
        filterAttrs (n: g: g.name == gname) cfg.extraGroups
      );
    in
      if length groups == 1 then head groups
      else if groups == [] then throw "Group ${gname} not defined"
      else throw "Group ${gname} has multiple definitions";

  getUser = uname:
    let
      users = mapAttrsToList (n: u: u) (
        filterAttrs (n: u: u.name == uname) cfg.extraUsers
      );
    in
      if length users == 1 then head users
      else if users == [] then throw "User ${uname} not defined"
      else throw "User ${uname} has multiple definitions";

  mkGroupEntry = gname:
    let
      g = getGroup gname;
      users = mapAttrsToList (n: u: u.name) (
        filterAttrs (n: u: elem g.name u.extraGroups) cfg.extraUsers
      );
    in concatStringsSep ":" [
      g.name "x" (toString g.gid)
      (concatStringsSep "," (users ++ (filter (u: !(elem u users)) g.members)))
    ];

  mkPasswdEntry = uname: let u = getUser uname; in
    concatStringsSep ":" [
      u.name "x" (toString u.uid)
      (toString (getGroup u.group).gid)
      u.description u.home u.shell
    ];

  sortOn = a: sort (as1: as2: lessThan (getAttr a as1) (getAttr a as2));

  groupFile = pkgs.writeText "group" (
    concatStringsSep "\n" (map (g: mkGroupEntry g.name) (
      sortOn "gid" (attrValues cfg.extraGroups)
    ))
  );

  passwdFile = pkgs.writeText "passwd" (
    concatStringsSep "\n" (map (u: mkPasswdEntry u.name) (
      sortOn "uid" (filter (u: u.createUser) (attrValues cfg.extraUsers))
    ))
  );

  # If mutableUsers is true, this script adds all users/groups defined in
  # users.extra{Users,Groups} to /etc/{passwd,group} iff there isn't any
  # existing user/group with the same name in those files.
  # If mutableUsers is false, the /etc/{passwd,group} files will simply be
  # replaced with the users/groups defined in the NixOS configuration.
  # The merging procedure could certainly be improved, and instead of just
  # keeping the lines as-is from /etc/{passwd,group} they could be combined
  # in some way with the generated content from the NixOS configuration.
  merger = src: pkgs.writeScript "merger" ''
    #!${pkgs.bash}/bin/bash

    PATH=${pkgs.gawk}/bin:${pkgs.gnugrep}/bin:$PATH

    ${if !cfg.mutableUsers
      then ''cp ${src} $1.tmp''
      else ''awk -F: '{ print "^"$1":.*" }' $1 | egrep -vf - ${src} | cat $1 - > $1.tmp''
    }

    # set mtime to +1, otherwise change might go unnoticed (vipw/vigr only looks at mtime)
    touch -m -t $(date -d @$(($(stat -c %Y $1)+1)) +%Y%m%d%H%M.%S) $1.tmp

    mv -f $1.tmp $1
  '';

in

{

  ###### interface

  options = {

    users.mutableUsers = mkOption {
      type = types.bool;
      default = true;
      description = ''
        If true, you are free to add new users and groups to the system
        with the ordinary <literal>useradd</literal> and
        <literal>groupadd</literal> commands. On system activation, the
        existing contents of the <literal>/etc/passwd</literal> and
        <literal>/etc/group</literal> files will be merged with the
        contents generated from the <literal>users.extraUsers</literal> and
        <literal>users.extraGroups</literal> options. If
        <literal>mutableUsers</literal> is false, the contents of the user and
        group files will simply be replaced on system activation. This also
        holds for the user passwords; if this option is false, all changed
        passwords will be reset according to the
        <literal>users.extraUsers</literal> configuration on activation. If
        this option is true, the initial password for a user will be set
        according to <literal>users.extraUsers</literal>, but existing passwords
        will not be changed.
      '';
    };

    users.extraUsers = mkOption {
      default = {};
      type = types.loaOf types.optionSet;
      example = {
        alice = {
          uid = 1234;
          description = "Alice Q. User";
          home = "/home/alice";
          createHome = true;
          group = "users";
          extraGroups = ["wheel"];
          shell = "/bin/sh";
        };
      };
      description = ''
        Additional user accounts to be created automatically by the system.
        This can also be used to set options for root.
      '';
      options = [ userOpts ];
    };

    users.extraGroups = mkOption {
      default = {};
      example =
        { students.gid = 1001;
          hackers = { };
        };
      type = types.loaOf types.optionSet;
      description = ''
        Additional groups to be created automatically by the system.
      '';
      options = [ groupOpts ];
    };

  };


  ###### implementation

  config = {

    users.extraUsers = {
      root = {
        uid = ids.uids.root;
        description = "System administrator";
        home = "/root";
        shell = cfg.defaultUserShell;
        group = "root";
        password = mkDefault "";
      };
      nobody = {
        uid = ids.uids.nobody;
        description = "Unprivileged account (don't use!)";
        group = "nogroup";
      };
    };

    users.extraGroups = {
      root.gid = ids.gids.root;
      wheel.gid = ids.gids.wheel;
      disk.gid = ids.gids.disk;
      kmem.gid = ids.gids.kmem;
      tty.gid = ids.gids.tty;
      floppy.gid = ids.gids.floppy;
      uucp.gid = ids.gids.uucp;
      lp.gid = ids.gids.lp;
      cdrom.gid = ids.gids.cdrom;
      tape.gid = ids.gids.tape;
      audio.gid = ids.gids.audio;
      video.gid = ids.gids.video;
      dialout.gid = ids.gids.dialout;
      nogroup.gid = ids.gids.nogroup;
      users.gid = ids.gids.users;
      nixbld.gid = ids.gids.nixbld;
      utmp.gid = ids.gids.utmp;
      adm.gid = ids.gids.adm;
    };

    system.activationScripts.users =
      let
        mkhomeUsers = filterAttrs (n: u: u.createHome) cfg.extraUsers;
        setpwUsers = filterAttrs (n: u: u.createUser) cfg.extraUsers;
        setpw = n: u: ''
          setpw=yes
          ${optionalString cfg.mutableUsers ''
            test "$(getent shadow '${u.name}' | cut -d: -f2)" != "x" && setpw=no
          ''}
          if [ "$setpw" == "yes" ]; then
            ${if u.password == ""
              then "passwd -d '${u.name}' &>/dev/null"
              else if (isNull u.password && isNull u.passwordFile)
              then "passwd -l '${u.name}' &>/dev/null"
              else if !(isNull u.password)
              then ''
                echo "${u.name}:${u.password}" | ${pkgs.shadow}/sbin/chpasswd''
              else ''
                echo -n "${u.name}:" | cat - "${u.passwordFile}" | \
                  ${pkgs.shadow}/sbin/chpasswd -e
              ''
            }
          fi
        '';
        mkhome = n: u:
         let
            uid = toString u.uid;
            gid = toString ((getGroup u.group).gid);
            h = u.home;
          in ''
            test -a "${h}" || mkdir -p "${h}" || true
            test "$(stat -c %u "${h}")" = ${uid} || chown ${uid} "${h}" || true
            test "$(stat -c %g "${h}")" = ${gid} || chgrp ${gid} "${h}" || true
          '';
      in stringAfter [ "etc" ] ''
        touch /etc/group
        touch /etc/passwd
        VISUAL=${merger groupFile} ${pkgs.shadow}/sbin/vigr &>/dev/null
        VISUAL=${merger passwdFile} ${pkgs.shadow}/sbin/vipw &>/dev/null
        ${pkgs.shadow}/sbin/grpconv
        ${pkgs.shadow}/sbin/pwconv
        ${concatStrings (mapAttrsToList mkhome mkhomeUsers)}
        ${concatStrings (mapAttrsToList setpw setpwUsers)}
      '';

    # for backwards compatibility
    system.activationScripts.groups = stringAfter [ "users" ] "";

  };

}
