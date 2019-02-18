# This file was generated by https://github.com/kamilchm/go2nix v1.2.1
{ stdenv, buildGoPackage, fetchFromGitHub, openssl, pandoc, pkgconfig }:

let
  version = "v1.6.1";
  goFuseVersion = with stdenv.lib; substring 0 7 (head (filter (
    d: d.goPackagePath == "github.com/hanwen/go-fuse"
  ) (import ./deps.nix))).fetch.rev;
in
buildGoPackage rec {
  name = "gocryptfs-${version}";

  goPackagePath = "github.com/rfjakob/gocryptfs";

  nativeBuildInputs = [ pandoc pkgconfig ];
  buildInputs = [ openssl ];

  src = fetchFromGitHub {
    owner = "rfjakob";
    repo = "gocryptfs";
    rev = version;
    sha256 = "0aqbl25g48b4jp6l09k6kic6w3p0q7d9ip2wvrcvh8lhnrbdkhzd";
  };

  postPatch = "rm -r tests";

  buildFlagsArray = ''
    -ldflags=
      -X main.GitVersion=${version}
      -X main.GitVersionFuse=${goFuseVersion}
  '';

  goDeps = ./deps.nix;

  postBuild = ''
    pushd go/src/github.com/rfjakob/gocryptfs/Documentation/
    mkdir -p $out/share/man/man1
    pandoc MANPAGE.md -s -t man -o $out/share/man/man1/gocryptfs.1
    pandoc MANPAGE-XRAY.md -s -t man -o $out/share/man/man1/gocryptfs-xray.1
    popd
  '';

  meta = with stdenv.lib; {
    description = "Encrypted overlay filesystem written in Go";
    license = licenses.mit;
    homepage = https://nuetzlich.net/gocryptfs/;
    maintainers = with maintainers; [ flokli offline ];
    platforms = platforms.unix;
  };
}
