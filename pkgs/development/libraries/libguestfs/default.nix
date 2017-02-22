{ stdenv, fetchurl, pkgconfig, autoreconfHook, makeWrapper
, ncurses, cpio, gperf, perl, cdrkit, flex, bison, qemu, pcre, augeas, libxml2
, acl, libcap, libcap_ng, libconfig, systemd, fuse, yajl, libvirt, hivex
, gmp, readline, file, libintlperl, GetoptLong, SysVirt, numactl, xen, libapparmor
, getopt, perlPackages, ocamlPackages }:

stdenv.mkDerivation rec {
  name = "libguestfs-${version}";
  version = "1.34.4";

  appliance = fetchurl {
    url = "http://libguestfs.org/download/binaries/appliance/appliance-1.34.0.tar.xz";
    sha256 = "0d7kg6ck9hwsqrxch69fhn49sbsjc8c40fr4753c35cq49f7xp6d";
  };

  src = fetchurl {
    url = "http://libguestfs.org/download/1.34-stable/libguestfs-${version}.tar.gz";
    sha256 = "1ca9i9d03pnfm7qqixvl48d7n0hn4ldmzlh2wcws45441prdxw3z";
  };

  buildInputs = [
    makeWrapper pkgconfig autoreconfHook ncurses cpio gperf perl
    cdrkit flex bison qemu pcre augeas libxml2 acl libcap libcap_ng libconfig
    systemd fuse yajl libvirt gmp readline file hivex libintlperl GetoptLong
    SysVirt numactl xen libapparmor getopt perlPackages.ModuleBuild
  ] ++ (with ocamlPackages; [ ocaml findlib ocamlbuild ocaml_libvirt ocaml_gettext ounit ]);

  prePatch = ''
    # build-time scripts
    substituteInPlace run.in        --replace '#!/bin/bash' '#!/bin/sh'
    substituteInPlace ocaml-link.sh --replace '#!/bin/bash' '#!/bin/sh'

    # $(OCAMLLIB) is read-only "${ocamlPackages.ocaml}/lib/ocaml"
    substituteInPlace ocaml/Makefile.am            --replace '$(DESTDIR)$(OCAMLLIB)' '$(out)/lib/ocaml'
    substituteInPlace ocaml/Makefile.in            --replace '$(DESTDIR)$(OCAMLLIB)' '$(out)/lib/ocaml'
    substituteInPlace v2v/test-harness/Makefile.am --replace '$(DESTDIR)$(OCAMLLIB)' '$(out)/lib/ocaml'
    substituteInPlace v2v/test-harness/Makefile.in --replace '$(DESTDIR)$(OCAMLLIB)' '$(out)/lib/ocaml'
  '';
  configureFlags = "--disable-appliance --disable-daemon";
  patches = [ ./libguestfs-syms.patch ];
  NIX_CFLAGS_COMPILE="-I${libxml2.dev}/include/libxml2/";
  installFlags = "REALLY_INSTALL=yes";

  postInstall = ''
    for bin in $out/bin/*; do
      wrapProgram "$bin" \
        --prefix "PATH" : "$out/bin:${hivex}/bin:${qemu}/bin" \
        --prefix "PERL5LIB" : "$PERL5LIB:$out/lib/perl5/site_perl"
    done
  '';

  postFixup = ''
    mkdir -p "$out/lib/guestfs"
    tar -Jxvf "$appliance" --strip 1 -C "$out/lib/guestfs"
  '';

  meta = with stdenv.lib; {
    description = "Tools for accessing and modifying virtual machine disk images";
    license = licenses.gpl2;
    homepage = http://libguestfs.org/;
    maintainers = with maintainers; [offline];
    platforms = platforms.linux;
    hydraPlatforms = [];
  };
}
