{ stdenv, fetchurl, xorg, ncurses, freetype, fontconfig, pkgconfig, makeWrapper
, enableDecLocator ? true
}:

stdenv.mkDerivation rec {
  name = "xterm-327";

  src = fetchurl {
    url = "ftp://invisible-island.net/xterm/${name}.tgz";
    sha256 = "02qmfr1y24y5vq6kddksw84b8gxalc96n9wwaj7i8hmk6mn2zyv6";
  };

  buildInputs =
    [ xorg.libXaw xorg.xproto xorg.libXt xorg.libXext xorg.libX11 xorg.libSM xorg.libICE
      ncurses freetype fontconfig pkgconfig xorg.libXft xorg.luit makeWrapper
    ];

  patches = [
    ./sixel-256.support.patch
  ];

  configureFlags = [
    "--enable-wide-chars"
    "--enable-256-color"
    "--enable-sixel-graphics"
    "--enable-regis-graphics"
    "--enable-load-vt-fonts"
    "--enable-i18n"
    "--enable-doublechars"
    "--enable-luit"
    "--enable-mini-luit"
    "--with-tty-group=tty"
    "--with-app-defaults=$(out)/lib/X11/app-defaults"
  ] ++ stdenv.lib.optional enableDecLocator "--enable-dec-locator";

  # Work around broken "plink.sh".
  NIX_LDFLAGS = "-lXmu -lXt -lICE -lX11 -lfontconfig";

  # Hack to get xterm built with the feature of releasing a possible setgid of 'utmp',
  # decided by the sysadmin to allow the xterm reporting to /var/run/utmp
  # If we used the configure option, that would have affected the xterm installation,
  # (setgid with the given group set), and at build time the environment even doesn't have
  # groups, and the builder will end up removing any setgid.
  postConfigure = ''
    echo '#define USE_UTMP_SETGID 1'
  '';

  postInstall = ''
    for bin in $out/bin/*; do
      wrapProgram $bin --set XAPPLRESDIR $out/lib/X11/app-defaults/
    done

    install -D -t $out/share/applications xterm.desktop
    install -D -t $out/share/icons/hicolor/48x48/apps icons/xterm-color_48x48.xpm
  '';

  meta = {
    homepage = http://invisible-island.net/xterm;
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [viric vrthra];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
