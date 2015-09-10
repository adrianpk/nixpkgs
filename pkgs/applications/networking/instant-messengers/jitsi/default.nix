{ stdenv, lib, fetchurl, makeDesktopItem, unzip, ant, jdk
# Optional, Jitsi still runs without, but you may pass null:
, alsaLib, dbus_libs, gtk2, libpulseaudio, openssl, xlibs
}:

stdenv.mkDerivation rec {

  name = "jitsi-${version}";
  version = "2.8.5426";

  src = fetchurl {
    url = "https://download.jitsi.org/jitsi/src/jitsi-src-${version}.zip";
    sha256 = "0v7k16in2i57z5amr7k5c3fc8f0azrzrs5dvn729bwbc31z8cjg6";
  };


  patches = [ ./jitsi.patch ];

  jitsiItem = makeDesktopItem {
    name = "Jitsi";
    exec = "jitsi";
    comment = "VoIP and Instant Messaging client";
    desktopName = "Jitsi";
    genericName = "Instant Messaging";
    categories = "Application;Internet;";
  };

  libPath = lib.makeLibraryPath ([
    stdenv.cc.cc  # For libstdc++.
  ] ++ lib.filter (x: x != null) [
    alsaLib
    dbus_libs
    gtk2
    libpulseaudio
    openssl
  ] ++ lib.optionals (xlibs != null) [
    xlibs.libX11
    xlibs.libXext
    xlibs.libXScrnSaver
    xlibs.libXv
  ]);

  buildInputs = [unzip ant jdk];

  buildPhase = ''ant make'';

  installPhase = ''
    mkdir -p $out
    cp -a lib $out/
    cp -a sc-bundles $out/
    mkdir $out/bin
    cp resources/install/generic/run.sh $out/bin/jitsi
    chmod +x $out/bin/jitsi
    substituteInPlace $out/bin/jitsi --replace '@JAVA@' '${jdk}/bin/java'
    patchShebangs $out

    libPath="$libPath:${jdk.jre.home}/lib/${jdk.architecture}"
    find $out/ -type f -name '*.so' | while read file; do
      patchelf --set-rpath "$libPath" "$file" && \
          patchelf --shrink-rpath "$file"
    done
  '';

  meta = {
    homepage = https://jitsi.org/;
    description = "Open Source Video Calls and Chat";
    license = stdenv.lib.licenses.lgpl21Plus.shortName;
    platforms = stdenv.lib.platforms.linux;
  };

}
