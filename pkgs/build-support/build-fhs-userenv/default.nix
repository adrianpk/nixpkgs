{ callPackage, runCommand, lib, writeScript, stdenv, coreutils, ruby }:

let buildFHSEnv = callPackage ./env.nix { }; in

args@{ name, runScript ? "bash", extraInstallCommands ? "", meta ? {}, passthru ? {}, ... }:

let
  env = buildFHSEnv (removeAttrs args [ "runScript" "extraInstallCommands" "meta" "passthru" ]);

  chrootenv = stdenv.mkDerivation {
    name = "chrootenv";

    unpackPhase = "cp ${./chrootenv.c} chrootenv.c";
    installPhase = "cp chrootenv $out";

    makeFlags = [ "chrootenv" ];
  };

  init = run: writeScript "${name}-init" ''
    #! ${stdenv.shell}
    for i in ${env}/* /host/*; do
      path="/''${i##*/}"
      [ -e "$path" ] || ${coreutils}/bin/ln -s "$i" "$path"
    done

    [ -d "$1" ] && [ -r "$1" ] && cd "$1"
    shift

    source /etc/profile
    exec ${run} "$@"
  '';

in runCommand name {
  inherit meta;
  passthru = passthru // {
    env = runCommand "${name}-shell-env" {
      shellHook = ''
        exec ${chrootenv} ${init "bash"} "$(pwd)"
      '';
    } ''
      echo >&2 ""
      echo >&2 "*** User chroot 'env' attributes are intended for interactive nix-shell sessions, not for building! ***"
      echo >&2 ""
      exit 1
    '';
  };
} ''
  mkdir -p $out/bin
  cat <<EOF >$out/bin/${name}
  #! ${stdenv.shell}
  exec ${chrootenv} ${init runScript} "\$(pwd)" "\$@"
  EOF
  chmod +x $out/bin/${name}
  ${extraInstallCommands}
''
