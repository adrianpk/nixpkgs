{stdenv, fetchurl, libstdcpp5, glib, pango, atk, gtk, libX11}:

# Note that RealPlayer 10 need libstdc++.so.5, i.e., GCC 3.3, not 3.4.

assert stdenv.system == "i686-linux";

(stdenv.mkDerivation {
  name = "RealPlayer-10.0.3.748-GOLD";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://software-dl.real.com/12ae5c4cc79d437fa106/unix/RealPlayer10GOLD.bin;
    md5 = "70a88bcae0ab3e177e6fadecd6b8be24";
  };

  makeWrapper = ../../../build-support/make-wrapper/make-wrapper.sh;

  inherit libstdcpp5;
  libPath = [libstdcpp5 glib pango atk gtk libX11];
  
}) // {mozillaPlugin = "/real/mozilla";}
