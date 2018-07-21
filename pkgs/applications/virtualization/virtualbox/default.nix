{ stdenv, fetchurl, lib, fetchpatch, iasl, dev86, pam, libxslt, libxml2
, libX11, xproto, libXext, libXcursor, libXmu, qt5, libIDL, SDL, libcap
, libpng, glib, lvm2, libXrandr, libXinerama
, pkgconfig, which, docbook_xsl, docbook_xml_dtd_43
, alsaLib, curl, libvpx, nettools, dbus
, xorriso, makeself, perl
, javaBindings ? false, jdk ? null
, pythonBindings ? false, python2 ? null
, enableExtensionPack ? false, requireFile ? null, fakeroot ? null
, pulseSupport ? false, libpulseaudio ? null
, enableHardening ? false
, headless ? false
, enable32bitGuests ? true
, patchelfUnstable # needed until 0.10 is released
}:

with stdenv.lib;

let
  python = python2;
  buildType = "release";
  # Manually sha256sum the extensionPack file, must be hex!
  # Do not forget to update the hash in ./guest-additions/default.nix!
  extpack = "d90c1b0c89de19010f7c7fe7a675ac744067baf29a9966b034e97b5b2053b37e";
  extpackRev = "123301";
  main = "ee3af129a581ec4c1a3e777e98247f8943e976ce6edd24962bcaa5c53ed1f644";
  version = "5.2.14";

  # See https://github.com/NixOS/nixpkgs/issues/672 for details
  extensionPack = requireFile rec {
    name = "Oracle_VM_VirtualBox_Extension_Pack-${version}-${toString extpackRev}.vbox-extpack";
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

in stdenv.mkDerivation {
  name = "virtualbox-${version}";

  src = fetchurl {
    url = "https://download.virtualbox.org/virtualbox/${version}/VirtualBox-${version}.tar.bz2";
    sha256 = main;
  };

  outputs = [ "out" "modsrc" ];

  nativeBuildInputs = [ pkgconfig which docbook_xsl docbook_xml_dtd_43 ];

  buildInputs =
    [ iasl dev86 libxslt libxml2 xproto libX11 libXext libXcursor libIDL
      libcap glib lvm2 alsaLib curl libvpx pam xorriso makeself perl
      libXmu libpng patchelfUnstable python ]
    ++ optional javaBindings jdk
    ++ optional pythonBindings python # Python is needed even when not building bindings
    ++ optional pulseSupport libpulseaudio
    ++ optionals (headless) [ libXrandr ]
    ++ optionals (!headless) [ qt5.qtbase qt5.qtx11extras libXinerama SDL ];

  hardeningDisable = [ "format" "fortify" "pic" "stackprotector" ];

  prePatch = ''
    set -x
    sed -e 's@MKISOFS --version@MKISOFS -version@' \
        -e 's@PYTHONDIR=.*@PYTHONDIR=${if pythonBindings then python else ""}@' \
        -e 's@CXX_FLAGS="\(.*\)"@CXX_FLAGS="-std=c++11 \1"@' \
        ${optionalString (!headless) ''
        -e 's@TOOLQT5BIN=.*@TOOLQT5BIN="${getDev qt5.qtbase}/bin"@' \
        ''} -i configure
    ls kBuild/bin/linux.x86/k* tools/linux.x86/bin/* | xargs -n 1 patchelf --set-interpreter ${stdenv.glibc.out}/lib/ld-linux.so.2
    ls kBuild/bin/linux.amd64/k* tools/linux.amd64/bin/* | xargs -n 1 patchelf --set-interpreter ${stdenv.glibc.out}/lib/ld-linux-x86-64.so.2

    grep 'libpulse\.so\.0'      src include -rI --files-with-match | xargs sed -i -e '
      ${optionalString pulseSupport
        ''s@"libpulse\.so\.0"@"${libpulseaudio.out}/lib/libpulse.so.0"@g''}'

    grep 'libdbus-1\.so\.3'     src include -rI --files-with-match | xargs sed -i -e '
      s@"libdbus-1\.so\.3"@"${dbus.lib}/lib/libdbus-1.so.3"@g'

    grep 'libasound\.so\.2'     src include -rI --files-with-match | xargs sed -i -e '
      s@"libasound\.so\.2"@"${alsaLib.out}/lib/libasound.so.2"@g'

    export USER=nix
    set +x
  '';

  patches =
     optional enableHardening ./hardened.patch
  ++ [
    ./qtx11extras.patch
    (fetchpatch {
      name = "010-qt-5.11.patch";
      url = "https://git.archlinux.org/svntogit/community.git/plain/trunk/010-qt-5.11.patch?h=packages/virtualbox";
      sha256 = "0hjx99pg40wqyggnrpylrp5zngva4xrnk7r90i0ynrqc7n84g9pn";
    })
  ];

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
    ${optionalString (!headless) ''
    PATH_QT5_X11_EXTRAS_LIB        := ${getLib qt5.qtx11extras}/lib
    PATH_QT5_X11_EXTRAS_INC        := ${getDev qt5.qtx11extras}/include
    TOOL_QT5_LRC                   := ${getDev qt5.qttools}/bin/lrelease
    ''}
    LOCAL_CONFIG

    ./configure \
      ${optionalString headless "--build-headless"} \
      ${optionalString (!javaBindings) "--disable-java"} \
      ${optionalString (!pythonBindings) "--disable-python"} \
      ${optionalString (!pulseSupport) "--disable-pulse"} \
      ${optionalString (!enableHardening) "--disable-hardening"} \
      ${optionalString (!enable32bitGuests) "--disable-vmmraw"} \
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

    mkdir -p $out/bin
    for file in ${optionalString (!headless) "VirtualBox VBoxSDL rdesktop-vrdp"} VBoxManage VBoxBalloonCtrl VBoxHeadless; do
        echo "Linking $file to /bin"
        test -x "$libexec/$file"
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

  passthru = {
    inherit version;       # for guest additions
    inherit extensionPack; # for inclusion in profile to prevent gc
  };

  meta = {
    description = "PC emulator";
    license = licenses.gpl2;
    homepage = https://www.virtualbox.org/;
    maintainers = with maintainers; [ flokli sander ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
