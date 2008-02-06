args:
let edf = args.lib.enableDisableFeature; in
( args.mkDerivationByConfiguration {
    flagConfig = {
      mandatory = { buildInputs = [ "popt" "pkgconfig" ]; };
      libX11 = { cfgOption = "--with-x11"; buildInputs = "libX11"; };
      no_libX11 = { cfgOption = "--without-x11"; };
    }
      # TODO! implement flags
      # I want to get kino and cinelerra working. That's why I don't spend more time on this now
      // edf "libtool_lock" "libtool_lock" { } #avoid locking (might break parallel builds)
      // edf "asm" "asm" { } #disable use of architecture specific assembly code
      // edf "SDL" "sdl" { buildInputs = "SDL"; } #enable use of SDL for display
      // edf "gtk" "gtk" { buildInputs = "gtk"; } #disable use of gtk for display
      // edf "libXv" "xv" { buildInputs = "libXv"; } #disable use of XVideo extension for display
      // edf "gprof" "gprof" { } #enable compiler options for gprof profiling
      // edf "shared" "shared" { }
      // edf "static" "static" { }
    ;

    extraAttrs = co : {
      name = "libdv-1.0.0";

      src = args.fetchurl {
        url = mirror://sourceforge/libdv/libdv-1.0.0.tar.gz;
        sha256 = "1fl96f2xh2slkv1i1ix7kqk576a0ak1d33cylm0mbhm96d0761d3";
      };

      meta = {
        description = "software decoder for DV format video, as defined by the IEC 61834 and SMPTE 314M standards";
        homepage = http://sourceforge.net/projects/libdv/;
        # you can choose one of the following licenses:
        license = [];
      };
    };
  optionals = [ "SDL" "gtk" "libXv" "libX11" ];
  defaults = [ "shared" "libtool_lock" ];
} ) args
