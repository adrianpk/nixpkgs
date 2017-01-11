{ stdenv, lib, fetchFromGitHub, fetchpatch, go-md2man
, go, pkgconfig, libapparmor, apparmor-parser, libseccomp }:

with lib;

stdenv.mkDerivation rec {
  name = "runc-${version}";
  version = "2016-06-15";

  src = fetchFromGitHub {
    owner = "opencontainers";
    repo = "runc";
    rev = "cc29e3dded8e27ba8f65738f40d251c885030a28";
    sha256 = "18fwb3kq10zhhx184yn3j396gpbppy3y4ypb8m2b2pdms39s6pyx";
  };

  patches = [
    # Two patches to fix CVE-2016-9962
    # From https://bugzilla.suse.com/show_bug.cgi?id=1012568
    (fetchpatch {
      name = "0001-libcontainer-nsenter-set-init-processes-as-non-dumpa.patch";
      url = "https://bugzilla.suse.com/attachment.cgi?id=709048&action=diff&context=patch&collapsed=&headers=1&format=raw";
      sha256 = "1cfsmsyhc45a2929825mdaql0mrhhbrgdm54ly0957j2f46072ck";
    })
    (fetchpatch {
      name = "0002-libcontainer-init-only-pass-stateDirFd-when-creating.patch";
      url = "https://bugzilla.suse.com/attachment.cgi?id=709049&action=diff&context=patch&collapsed=&headers=1&format=raw";
      sha256 = "1ykwg1mbvsxsnsrk9a8i4iadma1g0rgdmaj19dvif457hsnn31wl";
    })
  ];

  outputs = [ "out" "man" ];

  hardeningDisable = ["fortify"];

  buildInputs = [ go-md2man go pkgconfig libseccomp libapparmor apparmor-parser ];

  makeFlags = ''BUILDTAGS+=seccomp BUILDTAGS+=apparmor'';

  preBuild = ''
    patchShebangs .
    substituteInPlace libcontainer/apparmor/apparmor.go \
      --replace /sbin/apparmor_parser ${apparmor-parser}/bin/apparmor_parser
  '';

  installPhase = ''
    install -Dm755 runc $out/bin/runc

    # Include contributed man pages
    man/md2man-all.sh -q
    manRoot="$man/share/man"
    mkdir -p "$manRoot"
    for manDir in man/man?; do
      manBase="$(basename "$manDir")" # "man1"
      for manFile in "$manDir"/*; do
        manName="$(basename "$manFile")" # "docker-build.1"
        mkdir -p "$manRoot/$manBase"
        gzip -c "$manFile" > "$manRoot/$manBase/$manName.gz"
      done
    done
  '';

  preFixup = ''
    # remove references to go compiler
    while read file; do
      sed -ri "s,${go},$(echo "${go}" | sed "s,$NIX_STORE/[^-]*,$NIX_STORE/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee,"),g" $file
    done < <(find $out/bin -type f 2>/dev/null)
  '';

  meta = {
    homepage = https://runc.io/;
    description = "A CLI tool for spawning and running containers according to the OCI specification";
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
  };
}
