{ stdenv, fetchurl, fetchpatch, pkgconfig, zlib, freetype, libjpeg, jbig2dec, openjpeg
, libX11, libXext }:
stdenv.mkDerivation rec {
  name = "mupdf-1.4";

  src = fetchurl {
    url = "http://mupdf.com/download/archive/${name}-source.tar.gz";
    sha256 = "08pc6fv42sb9k9dzjs8ph32nixzrzmr08yxh7arkpsdm42asp2q1";
  };

  buildInputs = [ pkgconfig zlib freetype libjpeg jbig2dec openjpeg libX11 libXext ];

  enableParallelBuilding = true;

  preBuild = ''
    export makeFlags="prefix=$out build=release"
    export NIX_CFLAGS_COMPILE=" $NIX_CFLAGS_COMPILE -I$(echo ${openjpeg}/include/openjpeg-*) "
  '';

  postInstall = ''
    mkdir -p $out/share/applications
    cat > $out/share/applications/mupdf.desktop <<EOF
    [Desktop Entry]
    Type=Application
    Version=1.0
    Name=mupdf
    Comment=PDF viewer
    Exec=$out/bin/mupdf-x11
    Terminal=false
    EOF
  '';

  meta = {
    homepage = http://mupdf.com/;
    repositories.git = git://git.ghostscript.com/mupdf.git;
    description = "Lightweight PDF viewer and toolkit written in portable C";
    license = "GPLv3+";
    maintainers = with stdenv.lib.maintainers; [ viric ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
