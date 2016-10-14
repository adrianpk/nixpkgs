{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, gnome3, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "vertex-theme";
  version = "20161009";

  src = fetchFromGitHub {
    owner = "horst3180";
    repo = pname;
    rev = "c861918a7fccf6d0768d45d790a19a13bb23485e";
    sha256 = "13abgl18m04sj44gqipxbagpan4jqral65w59rgnhb6ldxgnhg33";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ gtk-engine-murrine ];

  configureFlags = [ "--disable-unity" "--with-gnome=${gnome3.version}" ];

  postInstall = ''
    mkdir -p $out/share/plank/themes
    cp -r extra/*-Plank $out/share/plank/themes

    mkdir -p $out/share/doc/$pname/Chrome
    cp -r extra/Chrome/*.crx $out/share/doc/$pname/Chrome
    cp -r extra/Firefox $out/share/doc/$pname
    cp AUTHORS README.md $out/share/doc/$pname/
  '';

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Theme for GTK 3, GTK 2, Gnome-Shell, and Cinnamon";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ rycee romildo ];
  };
}
