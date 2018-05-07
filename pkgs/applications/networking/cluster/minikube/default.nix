{ stdenv, buildGoPackage, fetchFromGitHub, fetchurl, go-bindata, libvirt, qemu, docker-machine-kvm,
  gpgme, makeWrapper, hostPlatform, vmnet }:

let binPath = stdenv.lib.optionals stdenv.isLinux [ libvirt qemu docker-machine-kvm ];

  # Normally, minikube bundles localkube in its own binary via go-bindata. Unfortunately, it needs to make that localkube
  # a static linux binary, and our Linux nixpkgs go compiler doesn't seem to work when asking for a cgo binary that's static
  # (presumably because we don't have some static system libraries it wants), and cross-compiling cgo on Darwin is a nightmare.
  #
  # Note that minikube can download (and cache) versions of localkube it needs on demand. Unfortunately, minikube's knowledge
  # of where it can download versions of localkube seems to rely on a json file that doesn't get updated as often as we'd like. So
  # instead, we download localkube ourselves and shove it into the minikube binary. The versions URL that minikube uses is
  # currently https://storage.googleapis.com/minikube/k8s_releases.json

  localkube-version = "1.10.0";
  localkube-binary = fetchurl {
    url = "https://storage.googleapis.com/minikube/k8sReleases/v${localkube-version}/localkube-linux-amd64";
    sha256 = "02lkl2g274689h07pkcwnxn04swy6aa3f2z77n421mx38bbq2kpd";
  };
in buildGoPackage rec {
  pname   = "minikube";
  name    = "${pname}-${version}";
  version = "0.27.0";

  goPackagePath = "k8s.io/minikube";

  src = fetchFromGitHub {
    owner  = "kubernetes";
    repo   = "minikube";
    rev    = "v${version}";
    sha256 = "00gj8x5p0vxwy0y0g5nnddmq049h7zxvhb73lb4gii5mghr9mkws";
  };

  patches = [
    ./localkube.patch
  ];

  buildInputs = [ go-bindata makeWrapper gpgme ] ++ stdenv.lib.optional hostPlatform.isDarwin vmnet;
  subPackages = [ "cmd/minikube" ];

  preBuild = ''
    pushd go/src/${goPackagePath} >/dev/null

    mkdir -p out
    cp ${localkube-binary} out/localkube

    go-bindata -nomemcopy -o pkg/minikube/assets/assets.go -pkg assets ./out/localkube deploy/addons/...

    ISO_VERSION=$(grep "^ISO_VERSION" Makefile | sed "s/^.*\s//")
    ISO_BUCKET=$(grep "^ISO_BUCKET" Makefile | sed "s/^.*\s//")

    export buildFlagsArray="-ldflags=\
      -X k8s.io/minikube/pkg/version.version=v${version} \
      -X k8s.io/minikube/pkg/version.isoVersion=$ISO_VERSION \
      -X k8s.io/minikube/pkg/version.isoPath=$ISO_BUCKET"

    popd >/dev/null
  '';

  postInstall = ''
    mkdir -p $bin/share/bash-completion/completions/
    MINIKUBE_WANTUPDATENOTIFICATION=false MINIKUBE_WANTKUBECTLDOWNLOADMSG=false HOME=$PWD $bin/bin/minikube completion bash > $bin/share/bash-completion/completions/minikube
    mkdir -p $bin/share/zsh/site-functions/
    MINIKUBE_WANTUPDATENOTIFICATION=false MINIKUBE_WANTKUBECTLDOWNLOADMSG=false HOME=$PWD $bin/bin/minikube completion zsh > $bin/share/zsh/site-functions/_minikube
  '';

  postFixup = "wrapProgram $bin/bin/${pname} --prefix PATH : ${stdenv.lib.makeBinPath binPath}";

  meta = with stdenv.lib; {
    homepage    = https://github.com/kubernetes/minikube;
    description = "A tool that makes it easy to run Kubernetes locally";
    license     = licenses.asl20;
    maintainers = with maintainers; [ ebzzry copumpkin ];
    platforms   = with platforms; unix;
  };
}
