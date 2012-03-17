{ stdenv, fetchurl, pkgconfig, gtk, libpng, exiv2, lcms
, intltool, gettext, fbida }:

stdenv.mkDerivation rec {
  name = "geeqie-1.0";

  src = fetchurl {
    url = "mirror://sourceforge/geeqie/${name}.tar.gz";
    sha256 = "1p8z47cqdqqkn8b0fr5bqsfinz4dgqk4353s8f8d9ha6cik69bfi";
  };

  configureFlags = [ "--enable-gps" ];

  buildInputs =
    [ pkgconfig gtk libpng exiv2 lcms intltool gettext
    ];

  postInstall =
    ''
      # Allow geeqie to find exiv2 and exiftran, necessary to
      # losslessly rotate JPEG images.
      sed -i $out/lib/geeqie/geeqie-rotate \
          -e '1 a export PATH=${exiv2}/bin:${fbida}/bin:$PATH'
    '';

  meta = {
    description = "Geeqie, a lightweight GTK+ based image viewer";

    longDescription =
      '' Geeqie is a lightweight GTK+ based image viewer for Unix like
         operating systems.  It features: EXIF, IPTC and XMP metadata
         browsing and editing interoperability; easy integration with other
         software; geeqie works on files and directories, there is no need to
         import images; fast preview for many raw image formats; tools for
         image comparison, sorting and managing photo collection.  Geeqie was
         initially based on GQview.
      '';

    license = "GPLv2+";

    homepage = http://geeqie.sourceforge.net;

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.gnu;
  };
}
