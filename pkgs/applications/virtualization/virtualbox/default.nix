{ stdenv, buildEnv, fetchurl, lib, iasl, dev86, pam, libxslt, libxml2, libX11, xproto, libXext
, libXcursor, libXmu, qt5, libIDL, SDL, libcap, zlib, libpng, glib, lvm2
, libXrandr, libXinerama
, which, alsaLib, curl, libvpx, gawk, nettools, dbus
, xorriso, makeself, perl, pkgconfig
, javaBindings ? false, jdk ? null
, pythonBindings ? false, python ? null
, enableExtensionPack ? false, requireFile ? null, patchelf ? null, fakeroot ? null
, pulseSupport ? false, libpulseaudio ? null
, enableHardening ? false
, headless ? false
}:

with stdenv.lib;

let
  buildType = "release";

  inherit (importJSON ./upstream-info.json) version extpackRev extpack main;

  # See https://github.com/NixOS/nixpkgs/issues/672 for details
  extensionPack = requireFile rec {
    name = "Oracle_VM_VirtualBox_Extension_Pack-${version}-${extpackRev}.vbox-extpack";
    sha256 = extpack;
    message = ''
      In order to use the extension pack, you need to comply with the VirtualBox Personal Use
      and Evaluation License (PUEL) available at:

      https://www.virtualbox.org/wiki/VirtualBox_PUEL

      Once you have read and if you agree with the license, please use the
      following command and re-run the installation:

      nix-prefetch-url http://download.virtualbox.org/virtualbox/${version}/${name}
    '';
  };

  vbox-qt5-env = buildEnv {
    name = "vbox-qt5-env-${version}";
    paths = [ qt5.qtbase.dev qt5.qtbase.out qt5.qtx11extras.dev qt5.qtx11extras.out qt5.qttools.dev ];
  };

in stdenv.mkDerivation {
  name = "virtualbox-${version}";

  src = fetchurl {
    url = "http://download.virtualbox.org/virtualbox/${version}/VirtualBox-${version}.tar.bz2";
    sha256 = main;
  };

  outputs = [ "out" "modsrc" ];

  buildInputs =
    [ iasl dev86 libxslt libxml2 xproto libX11 libXext libXcursor libIDL
      libcap glib lvm2 python alsaLib curl libvpx pam xorriso makeself perl
      pkgconfig which libXmu libpng ]
    ++ optional javaBindings jdk
    ++ optional pythonBindings python
    ++ optional pulseSupport libpulseaudio
    ++ optionals (headless) [ libXrandr ]
    ++ optionals (!headless) [ vbox-qt5-env libXinerama SDL ];

  hardeningDisable = [ "fortify" "pic" "stackprotector" ];

  prePatch = ''
    set -x
    sed -e 's@MKISOFS --version@MKISOFS -version@' \
        -e 's@PYTHONDIR=.*@PYTHONDIR=${if pythonBindings then python else ""}@' \
        -i configure
    ls kBuild/bin/linux.x86/k* tools/linux.x86/bin/* | xargs -n 1 patchelf --set-interpreter ${stdenv.glibc.out}/lib/ld-linux.so.2
    ls kBuild/bin/linux.amd64/k* tools/linux.amd64/bin/* | xargs -n 1 patchelf --set-interpreter ${stdenv.glibc.out}/lib/ld-linux-x86-64.so.2
    sed -i -e '
      s@"libdbus-1\.so\.3"@"${dbus.lib}/lib/libdbus-1.so.3"@g
      s@"libasound\.so\.2"@"${alsaLib.out}/lib/libasound.so.2"@g
      ${optionalString pulseSupport ''
      s@"libpulse\.so\.0"@"${libpulseaudio.out}/lib/libpulse.so.0"@g
      ''}
    ' src/VBox/Main/xml/Settings.cpp \
      src/VBox/Devices/Audio/{alsa,pulse}_stubs.c \
      include/VBox/dbus-calls.h
    export USER=nix
    set +x
  '';

  patches = optional enableHardening ./hardened.patch
    ++ [ ./libressl.patch ];

  postPatch = ''
    sed -i -e 's|/sbin/ifconfig|${nettools}/bin/ifconfig|' \
      src/VBox/HostDrivers/adpctl/VBoxNetAdpCtl.cpp
  '';

  # first line: ugly hack, and it isn't yet clear why it's a problem
  configurePhase = ''
    NIX_CFLAGS_COMPILE=$(echo "$NIX_CFLAGS_COMPILE" | sed 's,\-isystem ${lib.getDev stdenv.cc.libc}/include,,g')

    cat >> LocalConfig.kmk <<LOCAL_CONFIG
    VBOX_WITH_TESTCASES            :=
    VBOX_WITH_TESTSUITE            :=
    VBOX_WITH_VALIDATIONKIT        :=
    VBOX_WITH_DOCS                 :=
    VBOX_WITH_WARNINGS_AS_ERRORS   :=

    VBOX_WITH_ORIGIN               :=
    VBOX_PATH_APP_PRIVATE_ARCH_TOP := $out/share/virtualbox
    VBOX_PATH_APP_PRIVATE_ARCH     := $out/libexec/virtualbox
    VBOX_PATH_SHARED_LIBS          := $out/libexec/virtualbox
    VBOX_WITH_RUNPATH              := $out/libexec/virtualbox
    VBOX_PATH_APP_PRIVATE          := $out/share/virtualbox
    VBOX_PATH_APP_DOCS             := $out/doc
    ${optionalString javaBindings ''
    VBOX_JAVA_HOME                 := ${jdk}
    ''}
    LOCAL_CONFIG

    ./configure \
      ${optionalString headless "--build-headless"} \
      ${optionalString (!headless) "--with-qt-dir=${vbox-qt5-env}"} \
      ${optionalString (!javaBindings) "--disable-java"} \
      ${optionalString (!pythonBindings) "--disable-python"} \
      ${optionalString (!pulseSupport) "--disable-pulse"} \
      ${optionalString (!enableHardening) "--disable-hardening"} \
      --disable-kmods --with-mkisofs=${xorriso}/bin/xorrisofs
    sed -e 's@PKG_CONFIG_PATH=.*@PKG_CONFIG_PATH=${libIDL}/lib/pkgconfig:${glib.dev}/lib/pkgconfig ${libIDL}/bin/libIDL-config-2@' \
        -i AutoConfig.kmk
    sed -e 's@arch/x86/@@' \
        -i Config.kmk
    substituteInPlace Config.kmk --replace "VBOX_WITH_TESTCASES = 1" "#"
  '';

  enableParallelBuilding = true;

  buildPhase = ''
    source env.sh
    kmk -j $NIX_BUILD_CORES BUILD_TYPE="${buildType}"
  '';

  installPhase = ''
    libexec="$out/libexec/virtualbox"
    share="${if enableHardening then "$out/share/virtualbox" else "$libexec"}"

    # Install VirtualBox files
    mkdir -p "$libexec"
    find out/linux.*/${buildType}/bin -mindepth 1 -maxdepth 1 \
      -name src -o -exec cp -avt "$libexec" {} +

    # Create wrapper script
    mkdir -p $out/bin
    for file in VirtualBox VBoxManage VBoxSDL VBoxBalloonCtrl VBoxBFE VBoxHeadless; do
        ln -s "$libexec/$file" $out/bin/$file
    done

    ${optionalString enableExtensionPack ''
      mkdir -p "$share"
      "${fakeroot}/bin/fakeroot" "${stdenv.shell}" <<EXTHELPER
      "$libexec/VBoxExtPackHelperApp" install \
        --base-dir "$share/ExtensionPacks" \
        --cert-dir "$share/ExtPackCertificates" \
        --name "Oracle VM VirtualBox Extension Pack" \
        --tarball "${extensionPack}" \
        --sha-256 "${extensionPack.outputHash}"
      EXTHELPER
    ''}

    ${optionalString (!headless) ''
      # Create and fix desktop item
      mkdir -p $out/share/applications
      sed -i -e "s|Icon=VBox|Icon=$libexec/VBox.png|" $libexec/virtualbox.desktop
      ln -sfv $libexec/virtualbox.desktop $out/share/applications
      # Icons
      mkdir -p $out/share/icons/hicolor
      for size in `ls -1 $libexec/icons`; do
        mkdir -p $out/share/icons/hicolor/$size/apps
        ln -s $libexec/icons/$size/*.png $out/share/icons/hicolor/$size/apps
      done
    ''}

    cp -rv out/linux.*/${buildType}/bin/src "$modsrc"
  '';

  passthru = { inherit version; /* for guest additions */ };

  # Workaround for https://github.com/NixOS/patchelf/issues/93 (can be removed once this issue is addressed)
  dontPatchELF = true;

  meta = {
    description = "PC emulator";
    homepage = http://www.virtualbox.org/;
    maintainers = [ lib.maintainers.sander ];
    platforms = lib.platforms.linux;
  };
}
