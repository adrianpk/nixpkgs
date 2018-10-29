{ lib, stdenv, callPackage, runCommand, ruby }@defs:

# Use for simple installation of Ruby tools shipped in a Gem.
# Start with a Gemfile that includes `gem <toolgem>`
# > nix-shell -p bundler bundix
# (shell)> bundle lock
# (shell)> bundix
# Then use rubyTool in the default.nix:

# rubyTool { pname = "gemifiedTool"; gemdir = ./.; exes = ["gemified-tool"]; }
# The 'exes' parameter ensures that a copy of e.g. rake doesn't polute the system.
{
  # use the name of the name in question; its version will be picked up from the gemset
  pname
  # gemdir is the location of the Gemfile{,.lock} and gemset.nix; usually ./.
, gemdir
  # Exes is the list of executables provided by the gems in the Gemfile
, exes ? []
  # Scripts are ruby programs depend on gems in the Gemfile (e.g. scripts/rails)
, scripts ? []
, ruby ? defs.ruby
, gemfile ? null
, lockfile ? null
, gemset ? null
, preferLocalBuild ? false
, allowSubstitutes ? false
, installManpages ? true
, meta ? {}
, postBuild ? ""
, gemConfig ? null
}@args:

let
  basicEnv = (callPackage ../bundled-common {}) args;

  cmdArgs = removeAttrs args [ "pname" "postBuild" "gemConfig" ]
  // { inherit preferLocalBuild allowSubstitutes; }; # pass the defaults
in
   runCommand basicEnv.name cmdArgs ''
    mkdir -p $out/bin
    ${(lib.concatMapStrings (x: "ln -s '${basicEnv}/bin/${x}' $out/bin/${x};\n") exes)}
    ${(lib.concatMapStrings (s: "makeWrapper $out/bin/$(basename ${s}) $srcdir/${s} " +
            "--set BUNDLE_GEMFILE ${basicEnv.confFiles}/Gemfile "+
            "--set BUNDLE_PATH ${basicEnv}/${ruby.gemPath} "+
            "--set BUNDLE_FROZEN 1 "+
            "--set GEM_HOME ${basicEnv}/${ruby.gemPath} "+
            "--set GEM_PATH ${basicEnv}/${ruby.gemPath} "+
            "--run \"cd $srcdir\";\n") scripts)}

    ${lib.optionalString installManpages ''
    for section in {1..9}; do
      mandir="$out/share/man/man$section"
      find -L ${basicEnv}/${ruby.gemPath}/gems/${basicEnv.name} \( -wholename "*/man/*.$section" -o -wholename "*/man/man$section/*.$section" \) -print -execdir mkdir -p $mandir \; -execdir cp '{}' $mandir \;
    done
    ''}

    ${postBuild}
  ''
