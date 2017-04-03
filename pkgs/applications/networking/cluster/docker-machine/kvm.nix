# This file was generated by go2nix.
{ stdenv, buildGoPackage, fetchFromGitHub, libvirt, pkgconfig }:

buildGoPackage rec {
  name = "docker-machine-kvm-${version}";
  version = "0.8.2";

  goPackagePath = "github.com/dhiltgen/docker-machine-kvm";
  goDeps = ./kvm-deps.nix;

  src = fetchFromGitHub {
    rev    = "v${version}";
    owner  = "dhiltgen";
    repo   = "docker-machine-kvm";
    sha256 = "1p7s340wlcjvna3xa2x13nsnixfhbn5b7dhf9cqvxds2slizlm3p";
  };

  buildInputs = [ libvirt pkgconfig ];

  meta = with stdenv.lib; {
    homepage = https://github.com/dhiltgen/docker-machine-kvm;
    description = "KVM driver for docker-machine.";
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.unix;
  };
}
