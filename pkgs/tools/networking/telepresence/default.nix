{ lib, stdenv, pythonPackages, fetchgit, fetchFromGitHub, makeWrapper, git
, sshfs-fuse, torsocks, sshuttle, conntrack-tools , openssh, coreutils
, iptables, bash }:

let
  sshuttle-telepresence = lib.overrideDerivation sshuttle (p: {
    src = fetchgit {
      url = "https://github.com/datawire/sshuttle.git";
      rev = "32226ff14d98d58ccad2a699e10cdfa5d86d6269";
      sha256 = "1q20lnljndwcpgqv2qrf1k0lbvxppxf98a4g5r9zd566znhcdhx3";
      leaveDotGit = true;
    };

    buildInputs = p.buildInputs ++ [ git ];
    postPatch = "rm sshuttle/tests/client/test_methods_nat.py";
    postInstall = "mv $out/bin/sshuttle $out/bin/sshuttle-telepresence";
  });
in pythonPackages.buildPythonPackage rec {
  pname = "telepresence";
  version = "0.93";

  src = fetchFromGitHub {
    owner = "datawire";
    repo = "telepresence";
    rev = version;
    sha256 = "1x8yjcqj8v35a5pxy2rxaixbznb4vk8ll958b4l46gnkfxf1kh1d";
  };

  buildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/telepresence \
      --prefix PATH : ${lib.makeBinPath [
        sshfs-fuse
        torsocks
        conntrack-tools
        sshuttle-telepresence
        openssh
        coreutils
        iptables
        bash
      ]}
  '';

  doCheck = false;

  meta = {
    homepage = https://www.telepresence.io/;
    description = "Local development against a remote Kubernetes or OpenShift cluster";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ offline ];
  };
}
