# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, glib, gtk, gtk2hsBuildtools, gtksourceview, libc, mtl
, pkgconfig, text
}:

cabal.mkDerivation (self: {
  pname = "gtksourceview2";
  version = "0.13.1.0";
  sha256 = "1znmr694jxam9n5lgikrhf8wb4jwdml82a3mgnpfr482a8knndbn";
  buildDepends = [ glib gtk mtl text ];
  buildTools = [ gtk2hsBuildtools ];
  extraLibraries = [ libc pkgconfig ];
  pkgconfigDepends = [ gtksourceview ];
  meta = {
    homepage = "http://projects.haskell.org/gtk2hs/";
    description = "Binding to the GtkSourceView library";
    license = self.stdenv.lib.licenses.lgpl21;
    platforms = self.ghc.meta.platforms;
  };
})
