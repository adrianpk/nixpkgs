{ stdenv, fetchurl, makeDesktopItem, makeWrapper
, alsaLib, atk, at-spi2-atk, cairo, cups, dbus, expat, fontconfig, freetype, gdk_pixbuf
, glib, gtk3, libnotify, libX11, libXcomposite, libXcursor, libXdamage, libuuid
, libXext, libXfixes, libXi, libXrandr, libXrender, libXtst, nspr, nss, libxcb
, pango, systemd, libXScrnSaver, libcxx, libpulseaudio }:

stdenv.mkDerivation rec {

    pname = "discord";
    version = "0.0.7";
    name = "${pname}-${version}";

    src = fetchurl {
        url = "https://cdn.discordapp.com/apps/linux/${version}/${pname}-${version}.tar.gz";
        sha256 = "1jjlwbx80vwhc8il48lb4sqzdb8zdwg28d8vnxsvhcqylfhwf8d8";
    };

    nativeBuildInputs = [ makeWrapper ];

    libPath = stdenv.lib.makeLibraryPath [
        libcxx systemd libpulseaudio
        stdenv.cc.cc alsaLib atk at-spi2-atk cairo cups dbus expat fontconfig freetype
        gdk_pixbuf glib gtk3 libnotify libX11 libXcomposite libuuid
        libXcursor libXdamage libXext libXfixes libXi libXrandr libXrender
        libXtst nspr nss libxcb pango systemd libXScrnSaver
     ];

    installPhase = ''
        mkdir -p $out/{bin,opt/discord,share/pixmaps}
        mv * $out/opt/discord

        chmod +x $out/opt/discord/Discord
        patchelf --set-interpreter ${stdenv.cc.bintools.dynamicLinker} \
                 $out/opt/discord/Discord

        paxmark m $out/opt/discord/Discord

        wrapProgram $out/opt/discord/Discord --prefix LD_LIBRARY_PATH : ${libPath}

        ln -s $out/opt/discord/Discord $out/bin/
        ln -s $out/opt/discord/discord.png $out/share/pixmaps

        ln -s "${desktopItem}/share/applications" $out/share/
        '';

    desktopItem = makeDesktopItem {
      name = pname;
      exec = "Discord";
      icon = pname;
      desktopName = "Discord";
      genericName = meta.description;
      categories = "Network;InstantMessaging;";
    };

    meta = with stdenv.lib; {
        description = "All-in-one cross-platform voice and text chat for gamers";
        homepage = https://discordapp.com/;
        downloadPage = "https://github.com/crmarsh/discord-linux-bugs";
        license = licenses.unfree;
        maintainers = [ maintainers.ldesgoui maintainers.MP2E ];
        platforms = [ "x86_64-linux" ];
    };
}
