{ stdenv, fetchurl, makeDesktopItem, patchelf, makeWrapper, makeQtWrapper
, dbus_libs, fontconfig, freetype, gcc, glib
, libdrm, libffi, libICE, libSM
, libX11, libXcomposite, libXext, libXmu, libXrender, libxcb
, libxml2, libxslt, ncurses, zlib
, qtbase, qtdeclarative, qtwebkit, wmctrl
}:

# this package contains the daemon version of dropbox
# it's unfortunately closed source
#
# note: the resulting program has to be invoced as
# 'dropbox' because the internal python engine takes
# uses the name of the program as starting point.

# Dropbox ships with its own copies of some libraries.
# Unfortunately, upstream makes changes to the source of
# some libraries, rendering them incompatible with the
# open-source versions. Wherever possible, we must try
# to make the bundled libraries work, rather than replacing
# them with our own.

let
  # NOTE: When updating, please also update in current stable,
  # as older versions stop working
  version = "23.4.18";
  sha256 =
    {
      "x86_64-linux" = "0hil9dnhmq4d4yq277w48ql3nw8yfzjqgafb0waw6zbc6a18l7bz";
      "i686-linux"   = "15hcmqyfyx8z7qx3val5r7b9plckh50iy0mxxh2z1wbh96l03l3a";
    }."${stdenv.system}" or (throw "system ${stdenv.system} not supported");

  arch =
    {
      "x86_64-linux" = "x86_64";
      "i686-linux"   = "x86";
    }."${stdenv.system}" or (throw "system ${stdenv.system} not supported");

  # relative location where the dropbox libraries are stored
  appdir = "opt/dropbox";

  ldpath = stdenv.lib.makeLibraryPath
    [
      dbus_libs fontconfig freetype gcc.cc glib libdrm libffi libICE libSM
      libX11 libXcomposite libXext libXmu libXrender libxcb libxml2 libxslt
      ncurses zlib

      qtbase qtdeclarative qtwebkit
    ];

  desktopItem = makeDesktopItem {
    name = "dropbox";
    exec = "dropbox";
    comment = "Sync your files across computers and to the web";
    desktopName = "Dropbox";
    genericName = "File Synchronizer";
    categories = "Network;FileTransfer;";
    startupNotify = "false";
  };

in stdenv.mkDerivation {
  name = "dropbox-${version}";
  src = fetchurl {
    name = "dropbox-${version}.tar.gz";
    url = "https://dl-web.dropbox.com/u/17/dropbox-lnx.${arch}-${version}.tar.gz";
    inherit sha256;
  };

  sourceRoot = ".dropbox-dist";

  nativeBuildInputs = [ makeQtWrapper patchelf ];
  dontStrip = true; # already done

  installPhase = ''
    mkdir -p "$out/${appdir}"
    cp -r --no-preserve=mode "dropbox-lnx.${arch}-${version}"/* "$out/${appdir}/"

    # Vendored libraries interact poorly with our graphics drivers
    rm "$out/${appdir}/libdrm.so.2"
    rm "$out/${appdir}/libffi.so.6"
    rm "$out/${appdir}/libGL.so.1"
    rm "$out/${appdir}/libX11-xcb.so.1"

    # Cannot use vendored Qt libraries due to problem with xkbcommon
    rm "$out/${appdir}/"libQt5*.so.5
    rm "$out/${appdir}/qt.conf"
    rm -fr "$out/${appdir}/plugins"

    mkdir -p "$out/share/applications"
    cp "${desktopItem}/share/applications/"* $out/share/applications

    mkdir -p "$out/share/icons"
    ln -s "$out/${appdir}/images/hicolor" "$out/share/icons/hicolor"

    mkdir -p "$out/bin"
    RPATH="${ldpath}:$out/${appdir}"
    makeQtWrapper "$out/${appdir}/dropbox" "$out/bin/dropbox" \
      --prefix LD_LIBRARY_PATH : "$RPATH"

    chmod 755 $out/${appdir}/dropbox

    rm $out/${appdir}/wmctrl
    ln -s ${wmctrl}/bin/wmctrl $out/${appdir}/wmctrl
  '';

  fixupPhase = ''
    INTERP=$(cat $NIX_CC/nix-support/dynamic-linker)
    RPATH="${ldpath}:$out/${appdir}"
    getType='s/ *Type: *\([A-Z]*\) (.*/\1/'
    find "$out/${appdir}" -type f -print | while read obj; do
        dynamic=$(readelf -S "$obj" 2>/dev/null | grep "DYNAMIC" || true)
        if [[ -n "$dynamic" ]]; then

            if readelf -l "$obj" 2>/dev/null | grep "INTERP" >/dev/null; then
                echo "patching interpreter path in $type $obj"
                patchelf --set-interpreter "$INTERP" "$obj"
            fi

            type=$(readelf -h "$obj" 2>/dev/null | grep 'Type:' | sed -e "$getType")
            if [ "$type" == "EXEC" ] || [ "$type" == "DYN" ]; then

                echo "patching RPATH in $type $obj"
                oldRPATH=$(patchelf --print-rpath "$obj")
                patchelf --set-rpath "''${oldRPATH:+$oldRPATH:}$RPATH" "$obj"

            else

                echo "unknown ELF type \"$type\"; not patching $obj"

            fi
        fi
    done

    paxmark m $out/${appdir}/dropbox
  '';

  meta = {
    homepage = "http://www.dropbox.com";
    description = "Online stored folders (daemon version)";
    maintainers = with stdenv.lib.maintainers; [ ttuegel ];
    platforms = [ "i686-linux" "x86_64-linux" ];
    license = stdenv.lib.licenses.unfree;
  };
}
