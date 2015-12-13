{ stdenv, erlang, rebar3, openssl, libyaml, fetchHex, fetchFromGitHub,
  rebar3-pc }:

{ name, version, sha256
, hexPkg ? name
, buildInputs ? [], erlangDeps ? [], pluginDeps ? []
, postPatch ? ""
, compilePorts ? false
, meta ? {}
, ... }@attrs:

with stdenv.lib;

stdenv.mkDerivation (attrs // {
  name = "${name}-${version}";

  buildInputs = buildInputs ++ [ erlang rebar3 openssl libyaml ];

  src = fetchHex {
    pkg = hexPkg;
    inherit version;
    inherit sha256;
  };

  postPatch = let
    registrySnapshot = import ./registrySnapshot.nix { inherit fetchFromGitHub; };
  in ''
    rm -f rebar rebar3
    if [ -e "src/${name}.app.src" ]; then
      sed -i -e 's/{ *vsn *,[^}]*}/{vsn, "${version}"}/' "src/${name}.app.src"
    fi

    # TODO: figure out how to provide 'pc' plugin hermetically
    ${if compilePorts then ''
    echo "{plugins, [pc]}." >> rebar.config
    '' else ''''}

    mkdir -p _build/default/{lib,plugins}/ ./.cache/rebar3/hex/default/
    zcat ${registrySnapshot}/registry.ets.gz > .cache/rebar3/hex/default/registry

    ${postPatch}
  '';

  configurePhase = let
    plugins = pluginDeps ++ (if compilePorts then [rebar3-pc] else []);
    getDeps = drv: [drv] ++ (map getDeps drv.erlangDeps);
    recursiveDeps = unique (flatten (map getDeps erlangDeps));
    recursivePluginsDeps = unique (flatten (map getDeps plugins));
  in ''
    runHook preConfigure
    ${concatMapStrings (dep: ''
      header "linking erlang dependency ${dep}"
      ln -s "${dep}" "_build/default/lib/${dep.packageName}"
      stopNest
    '') recursiveDeps}
    ${concatMapStrings (dep: ''
      header "linking rebar3 plugins ${dep}"
      ln -s "${dep}" "_build/default/plugins/${dep.packageName}"
      stopNest
    '') recursivePluginsDeps}
    runHook postConfigure
  '';

  # TODO: figure out how to provide rebar3 a static registry snapshot to make
  # this hermetic
  buildPhase = ''
    runHook preBuild
    HOME=. rebar3 compile
    ${if compilePorts then ''
    HOME=. rebar3 pc compile
    '' else ''''}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir "$out"
    for reldir in src ebin priv include; do
      fd="_build/default/lib/${name}/$reldir"
      [ -d "$fd" ] || continue
      cp -Hrt "$out" "$fd"
      success=1
    done
    runHook postInstall
  '';

  meta = {
    inherit (erlang.meta) platforms;
  } // meta;

  passthru = {
    packageName = name;
    inherit erlangDeps;
  };
})
