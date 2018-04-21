# This file was generated by https://github.com/kamilchm/go2nix v2.0-dev
{ stdenv, buildGoPackage, zip, fetchFromGitHub }:

buildGoPackage rec {
  name = "teleport-${version}";
  version = "2.4.1";

  # This repo has a private submodule "e" which fetchgit cannot handle without failing.
  src = fetchFromGitHub {
    owner = "gravitational";
    repo = "teleport";
    rev = "v${version}";
    sha256 = "09kmlihv4aqc39f9cyv2vm0kqgdf9vmdrgds5krnzqdgy3svyg7y";
  };

  goPackagePath = "github.com/gravitational/teleport";
  subPackages = [ "tool/tctl" "tool/teleport" "tool/tsh" ];
  buildInputs = [ zip ];
  postBuild = ''
    pushd .
    cd $NIX_BUILD_TOP/go/src/github.com/gravitational/teleport
    mkdir -p build
    echo "making webassets"
    make build/webassets.zip
    cat build/webassets.zip >> $NIX_BUILD_TOP/go/bin/teleport
    rm -fr build/webassets.zip
    cd $NIX_BUILD_TOP/go/bin
    zip -q -A teleport
    popd
    '';

  dontStrip = true;

  meta = {
    description = "A SSH CA management suite";
    homepage = "https://gravitational.com/teleport/";
    license = stdenv.lib.licenses.asl20;
    maintainers = [ stdenv.lib.maintainers.tomberek ];
    platforms = stdenv.lib.platforms.linux;
  };
}
