{stdenv, fetchurl, wxPython}:

assert wxPython.python.zlibSupport;

stdenv.mkDerivation {
  name = "bittorrent-3.4.2";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/bittorrent/BitTorrent-3.4.2.tar.gz;
    md5 = "b854f25a33289565bcaeaded04955c1a";
  };
  inherit wxPython;
  inherit (wxPython) python;
}
