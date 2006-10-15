{ stdenv, fetchurl, which, qt3, x11
, libX11, libXinerama, libXv, libXxf86vm, libXrandr, libXmu
, lame, zlib, mesa}:

assert qt3.mysqlSupport;

stdenv.mkDerivation {
  name = "mythtv-0.20";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/mythtv-0.20.tar.bz2;
    md5 = "52bec1e0fadf7d24d6dcac3f773ddf74";
  };

  configureFlags = "--disable-joystick-menu --x11-path=/no-such-path --dvb-path=/no-such-path";

  buildInputs = [
    which qt3 x11
    libX11 libXinerama libXv libXxf86vm libXrandr libXmu
    lame zlib mesa
  ];
  
  patches = [
    ./settings.patch
    ./purity.patch # don't search in /usr/include etc.
  ];

  /* Quick workaround for NIXPKGS-30 to get floor() etc. to work in
     MythTV.  Can be removed once NIXPKGS-30 has been fixed. */
  NIX_CFLAGS_COMPILE = "-ffast-math";
}
