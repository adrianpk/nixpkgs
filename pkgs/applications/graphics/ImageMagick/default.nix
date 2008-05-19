args: with args;

let version = "6.4.1-1"; in

stdenv.mkDerivation (rec {
  name = "ImageMagick-${version}";

  src = fetchurl {
    url = "mirror://imagemagick/${name}.tar.bz2";
    sha256 = "0a8defbfa867bb5e969f898d9a3b65a8c4f6952cb71411b40f005dd0a183644e";
  };

  configureFlags = ''
    --with-dots
    --with-gs-font-dir=${ghostscript}/share/ghostscript/fonts
    --with-gslib
    ${if args ? tetex then "--with-frozenpaths" else ""}
  '';

  buildInputs =
    [ bzip2 freetype ghostscript graphviz libjpeg libpng
      libtiff libX11 libxml2 zlib libtool
    ]
    ++ stdenv.lib.optional (args ? tetex) args.tetex
    ++ stdenv.lib.optional (args ? librsvg) args.librsvg;

  preConfigure = if args ? tetex then
    ''
      export DVIDecodeDelegate=${args.tetex}/bin/dvips
    '' else "";

  meta = {
    homepage = http://www.imagemagick.org;
  };
})
