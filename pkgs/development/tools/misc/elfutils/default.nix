{ lib, stdenv, fetchurl, m4, zlib, bzip2, bison, flex, gettext, xz }:

# TODO: Look at the hardcoded paths to kernel, modules etc.
stdenv.mkDerivation rec {
  name = "elfutils-${version}";
  version = "0.165";

  src = fetchurl {
    url = "http://fedorahosted.org/releases/e/l/elfutils/${version}/${name}.tar.bz2";
    sha256 = "0wp91hlh9n0ismikljf63558rzdwim8w1s271grsbaic35vr5z57";
  };

  patches = [ ./glibc-2.21.patch ];

  hardeningDisable = [ "format" ];

  # We need bzip2 in NativeInputs because otherwise we can't unpack the src,
  # as the host-bzip2 will be in the path.
  nativeBuildInputs = [ m4 bison flex gettext bzip2 ];
  buildInputs = [ zlib bzip2 xz ];

  configureFlags =
    [ "--program-prefix=eu-" # prevent collisions with binutils
      "--enable-deterministic-archives"
    ];

  enableParallelBuilding = true;

  crossAttrs = {

    /* Having bzip2 will harm, because anything using elfutils
       as buildInput cross-building, will not be able to run 'bzip2' */
    propagatedBuildInputs = [ zlib.crossDrv ];

    # This program does not cross-build fine. So I only cross-build some parts
    # I need for the linux perf tool.
    # On the awful cross-building:
    # http://comments.gmane.org/gmane.comp.sysutils.elfutils.devel/2005
    #
    # I wrote this testing for the nanonote.
    buildPhase = ''
      pushd libebl
      make
      popd
      pushd libelf
      make
      popd
      pushd libdwfl
      make
      popd
      pushd libdw
      make
      popd
    '';

    installPhase = ''
      pushd libelf
      make install
      popd
      pushd libdwfl
      make install
      popd
      pushd libdw
      make install
      popd
      cp version.h $out/include
    '';
  };

  meta = {
    homepage = https://fedorahosted.org/elfutils/;
    description = "A set of utilities to handle ELF objects";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.eelco ];
  };
}
