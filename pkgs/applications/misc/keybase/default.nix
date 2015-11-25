{ stdenv, fetchurl, makeWrapper, callPackage, gnupg, utillinux }:

with stdenv.lib;

let 
  nodePackages = callPackage (import ../../../top-level/node-packages.nix) {
    neededNatives = [] ++ optional (stdenv.isLinux) utillinux;
    self = nodePackages;
    generated = ./package.nix;
  };

in nodePackages.buildNodePackage rec {
  name = "keybase-${version}";
  version = "0.8.22";

  src = [(fetchurl {
    url = "https://github.com/keybase/node-client/archive/v${version}.tar.gz";
    sha256 = "1dvwz2iqcybd687hp6zbw6lkpx27vp8ah6kk251147vxvwfjb422";
  })];

  deps = (filter (v: nixType v == "derivation") (attrValues nodePackages));
  buildInputs = [ makeWrapper gnupg ];

  postInstall = ''
    wrapProgram "$out/bin/keybase" --set NODE_PATH "$out/lib/node_modules/keybase/node_modules/"
  '';

  passthru.names = ["keybase"];

  meta = {
    description = "CLI for keybase.io written in/for Node.js";
    license = licenses.mit;
    homepage = https://keybase.io/docs/command_line;
    maintainers = with maintainers; [manveru];
    platforms = platforms.linux;
  };
}
