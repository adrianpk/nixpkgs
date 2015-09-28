{ stdenv, src, pkgconfig, tcl, libXft, fontconfig, patches ? [], ... }:

stdenv.mkDerivation {
  name = "tk-${tcl.version}";

  inherit src patches;

  postInstall = ''
    ln -s $out/bin/wish* $out/bin/wish
  '';

  preConfigure = ''
    cd unix
  '';

  configureFlags = [
    "--with-tcl=${tcl}/lib"
  ];

  buildInputs = [ pkgconfig tcl libXft ]
    ++ stdenv.lib.optional stdenv.isDarwin fontconfig;

  NIX_CFLAGS_LINK = if stdenv.isDarwin then "-lfontconfig" else null;

  inherit tcl;

  passthru = rec {
    inherit (tcl) release version;
    libPrefix = "tk${tcl.release}";
    libdir = "lib/${libPrefix}";
  };

  meta = with stdenv.lib; {
    description = "A widget toolkit that provides a library of basic elements for building a GUI in many different programming languages";
    homepage = http://www.tcl.tk/;
    license = licenses.tcltk;
    platforms = platforms.all;
    maintainers = with maintainers; [ lovek323 wkennington ];
  };
}
