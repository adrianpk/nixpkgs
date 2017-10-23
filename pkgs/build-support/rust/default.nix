{ fetchurl, stdenv, path, cacert, git, rust }:
let
  cargoVendor = import ./cargo-vendor.nix {
    inherit fetchurl stdenv;
  };

  fetchcargo = import ./fetchcargo.nix {
    inherit stdenv cacert git rust cargoVendor;
  };
in
{ name, cargoSha256
, src ? null
, srcs ? null
, sourceRoot ? null
, logLevel ? ""
, buildInputs ? []
, cargoUpdateHook ? ""
, cargoDepsHook ? ""
, cargoBuildFlags ? []
, ... } @ args:

let
  lib = stdenv.lib;

  cargoDeps = fetchcargo {
    inherit name src srcs sourceRoot cargoUpdateHook;
    sha256 = cargoSha256;
  };

in stdenv.mkDerivation (args // {
  inherit cargoDeps;

  patchRegistryDeps = ./patch-registry-deps;

  buildInputs = [ git rust.cargo rust.rustc ] ++ buildInputs;

  configurePhase = args.configurePhase or ''
    runHook preConfigure
    # noop
    runHook postConfigure
  '';

  postUnpack = ''
    eval "$cargoDepsHook"

    if [[ ! -f $cargoDeps/.config ]]; then
      echo "ERROR: file not found: $cargoDeps/.config"
      echo "try updating the cargoSha256"
      exit 1
    fi

    mkdir -p .cargo
    # inherit cargo config from the deps, rewrite the target directory
    cat $cargoDeps/.config | sed "s|REPLACEME|$cargoDeps|g" > .cargo/config

    export RUST_LOG=${logLevel}
    export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
  '' + (args.postUnpack or "");

  buildPhase = with builtins; args.buildPhase or ''
    runHook preBuild
    echo "Running cargo build --release ${concatStringsSep " " cargoBuildFlags}"
    cargo build --release --frozen ${concatStringsSep " " cargoBuildFlags}
    runHook postBuild
  '';

  checkPhase = args.checkPhase or ''
    runHook preCheck
    echo "Running cargo test"
    cargo test
    runHook postCheck
  '';

  doCheck = args.doCheck or true;

  installPhase = args.installPhase or ''
    runHook preInstall
    mkdir -p $out/bin
    find target/release -maxdepth 1 -executable -exec cp "{}" $out/bin \;
    runHook postInstall
  '';

  passthru = { inherit cargoDeps; } // (args.passthru or {});
})
