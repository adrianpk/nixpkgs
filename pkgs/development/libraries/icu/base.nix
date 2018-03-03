{ version, sha256, patches ? [], patchFlags ? "" }:
{ stdenv, fetchurl, fetchpatch, fixDarwinDylibNames
  # Cross-compiled icu4c requires a build-root of a native compile
, buildRootOnly ? false, nativeBuildRoot, buildPlatform, hostPlatform
}:

let
  pname = "icu4c";

  baseAttrs = {
    src = fetchurl {
      url = "http://download.icu-project.org/files/${pname}/${version}/${pname}-"
        + (stdenv.lib.replaceChars ["."] ["_"] version) + "-src.tgz";
      inherit sha256;
    };

    postUnpack = ''
      sourceRoot=''${sourceRoot}/source
      echo Source root reset to ''${sourceRoot}
    '';

    # https://sourceware.org/glibc/wiki/Release/2.26#Removal_of_.27xlocale.h.27
    postPatch = if (stdenv.hostPlatform.libc == "glibc" || stdenv.hostPlatform.libc == "musl")
      then "substituteInPlace i18n/digitlst.cpp --replace '<xlocale.h>' '<locale.h>'"
      else null; # won't find locale_t on darwin

    inherit patchFlags patches;

    preConfigure = ''
      sed -i -e "s|/bin/sh|${stdenv.shell}|" configure

      # $(includedir) is different from $(prefix)/include due to multiple outputs
      sed -i -e 's|^\(CPPFLAGS = .*\) -I\$(prefix)/include|\1 -I$(includedir)|' config/Makefile.inc.in
    '' + stdenv.lib.optionalString stdenv.isArm ''
      # From https://archlinuxarm.org/packages/armv7h/icu/files/icudata-stdlibs.patch
      sed -e 's/LDFLAGSICUDT=-nodefaultlibs -nostdlib/LDFLAGSICUDT=/' -i config/mh-linux
    '';

    configureFlags = "--disable-debug" +
      stdenv.lib.optionalString (stdenv.isFreeBSD || stdenv.isDarwin) " --enable-rpath" +
      stdenv.lib.optionalString (buildPlatform != hostPlatform) " --with-cross-build=${nativeBuildRoot}";

    enableParallelBuilding = true;

    meta = with stdenv.lib; {
      description = "Unicode and globalization support library";
      homepage = http://site.icu-project.org/;
      maintainers = with maintainers; [ raskin ];
      platforms = platforms.all;
    };
  };

  realAttrs = baseAttrs // {
    name = pname + "-" + version;

    outputs = [ "out" "dev" ];
    outputBin = "dev";

    # FIXME: This fixes dylib references in the dylibs themselves, but
    # not in the programs in $out/bin.
    buildInputs = stdenv.lib.optional stdenv.isDarwin fixDarwinDylibNames;

    # remove dependency on bootstrap-tools in early stdenv build
    postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
      sed -i 's/INSTALL_CMD=.*install/INSTALL_CMD=install/' $out/lib/icu/${version}/pkgdata.inc
    '' + ''
      substituteInPlace "$dev/bin/icu-config" \
        --replace \''${pkglibdir}/Makefile.inc "$dev/lib/icu/Makefile.inc"
    '';

    postFixup = ''moveToOutput lib/icu "$dev" '';
  };

  buildRootOnlyAttrs = baseAttrs // {
    name = pname + "-build-root-" + version;

    preConfigure = baseAttrs.preConfigure + ''
      mkdir build
      cd build
      configureScript=../configure
    '';

    postBuild = ''
      cd ..
      mv build $out
      echo "Doing build-root only, exiting now" >&2
      exit 0
    '';
  };

  attrs = if buildRootOnly
            then buildRootOnlyAttrs
          else realAttrs;
in
stdenv.mkDerivation attrs
