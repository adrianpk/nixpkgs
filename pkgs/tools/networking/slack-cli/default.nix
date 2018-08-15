# slack-cli must be configured using the SLACK_CLI_TOKEN environment variable.
# Using `slack init` will not work because it tries to write to the Nix store.
#
# There is no reason that we couldn't change the file path that slack-cli uses
# for token storage, except that it would make the Nix package inconsistent with
# upstream and other distributions.

{ stdenv, lib, writeShellScriptBin, fetchFromGitHub, curl, jq }:

let
  wrapper = writeShellScriptBin "slack" ''
    [ "$1" = "init" -a -z "$SLACK_CLI_TOKEN" ] && cat >&2 <<-'MESSAGE'
    WARNING: slack-cli must be configured using the SLACK_CLI_TOKEN environment
    variable. Using `slack init` will not work because it tries to write to the
    Nix store.

    MESSAGE

    export PATH=${lib.makeBinPath [ curl jq ]}:"$PATH"
    exec "$(dirname "$0")/.slack-wrapped" "$@"
  '';

in stdenv.mkDerivation rec {
    name = "slack-cli-${version}";
    version = "0.18.0";

    src = fetchFromGitHub {
      owner = "rockymadden";
      repo = "slack-cli";
      rev = "v${version}";
      sha256 = "022yr3cpfg0v7cxi62zzk08vp0l3w851qpfh6amyfgjiynnfyddl";
    };

    dontBuild = true;

    installPhase = ''
      mkdir -p "$out/bin"
      cp src/slack "$out/bin/.slack-wrapped"
      ln -s ${wrapper}/bin/slack "$out/bin/slack"
    '';

    meta = {
      license = lib.licenses.mit;
      maintainers = [ lib.maintainers.qyliss ];
      platforms = lib.platforms.unix;
    };
  }
