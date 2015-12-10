{ stdenv, fetchFromGitHub, makeWrapper
, go, sqlite, iproute, bridge-utils, devicemapper
, btrfsProgs, iptables, e2fsprogs, xz, utillinux
, enableLxc ? false, lxc
}:

# https://github.com/docker/docker/blob/master/project/PACKAGERS.md

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "docker-${version}";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "docker";
    rev = "v${version}";
    sha256 = "1a1ss210i712fs9mp5hcljb8bdx93lss91sxj9zay0vrmdb84zn2";
  };

  buildInputs = [
    makeWrapper go sqlite iproute bridge-utils devicemapper btrfsProgs
    iptables e2fsprogs stdenv.glibc stdenv.glibc.static
  ];

  dontStrip = true;

  buildPhase = ''
    patchShebangs .
    export AUTO_GOPATH=1
    export DOCKER_GITCOMMIT="76d6bc9a"
    ./hack/make.sh dynbinary
  '';

  installPhase = ''
    install -Dm755 ./bundles/${version}/dynbinary/docker-${version} $out/libexec/docker/docker
    install -Dm755 ./bundles/${version}/dynbinary/dockerinit-${version} $out/libexec/docker/dockerinit
    makeWrapper $out/libexec/docker/docker $out/bin/docker \
      --prefix PATH : "${iproute}/sbin:sbin:${iptables}/sbin:${e2fsprogs}/sbin:${xz}/bin:${utillinux}/bin:${optionalString enableLxc "${lxc}/bin"}"

    # systemd
    install -Dm644 ./contrib/init/systemd/docker.service $out/etc/systemd/system/docker.service

    # completion
    install -Dm644 ./contrib/completion/bash/docker $out/share/bash-completion/completions/docker
    install -Dm644 ./contrib/completion/zsh/_docker $out/share/zsh/site-functions/_docker
  '';

  meta = with stdenv.lib; {
    homepage = http://www.docker.com/;
    description = "An open source project to pack, ship and run any application as a lightweight container";
    license = licenses.asl20;
    maintainers = with maintainers; [ offline tailhook ];
    platforms = platforms.linux;
  };
}
