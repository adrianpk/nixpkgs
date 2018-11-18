{ stdenv, fetchFromGitHub,
  libtool, gettext, pkgconfig,
  vala, gnome-common, gobjectIntrospection,
  libgee, json-glib, skk-dicts, libxkbcommon }:

stdenv.mkDerivation rec {
  name = "libskk-${version}";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "ueno";
    repo = "libskk";
    rev = version;
    sha256 = "0y279pcgs3jrsi9vzx086xhz9jbz23dqqijp4agygc9ackp9sxy5";
  };

  buildInputs = [ skk-dicts libxkbcommon ];
  nativeBuildInputs = [ vala gnome-common gobjectIntrospection libtool gettext pkgconfig ];
  propagatedBuildInputs = [ libgee json-glib ];

  preConfigure = ''
    ./autogen.sh
  '';

  # link SKK-JISYO.L from skkdicts for the bundled tool `skk`
  preInstall = ''
    dictDir=$out/share/skk
    mkdir -p $dictDir
    ln -s ${skk-dicts}/share/SKK-JISYO.L $dictDir/
  '';

  enableParallelBuilding = true;

  meta = {
    description = "A library to deal with Japanese kana-to-kanji conversion method";
    longDescription = ''
      Libskk is a library that implements basic features of SKK including:
      new word registration, completion, numeric conversion, abbrev mode, kuten input,
      hankaku-katakana input, Lisp expression evaluation (concat only), and re-conversion.
      It also supports various typing rules including: romaji-to-kana, AZIK, TUT-Code, and NICOLA,
      as well as various dictionary types including: file dictionary (such as SKK-JISYO.[SML]),
      user dictionary, skkserv, and CDB format dictionary.
    '';
    homepage = https://github.com/ueno/libskk;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [ yuriaisaka ];
    platforms = stdenv.lib.platforms.linux;
  };
}
