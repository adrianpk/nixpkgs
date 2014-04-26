{ stdenv, fetchurl, patchelf }:

let
  arch = if stdenv.system == "x86_64-linux" then "x64"
    else if stdenv.system == "i686-linux" then "i386"
    else throw "Bittorrent Sync for: ${stdenv.system} not supported!";

  sha256 = if stdenv.system == "x86_64-linux" then "0q91fwzvb5ybl43z9nirnk3bs13z0z5vf0cqdyynqwa93an6wiaq"
    else if stdenv.system == "i686-linux" then "1y7i9p7fs23ksv8qhcb5gxlrm0wxs090jvdm58war13bg9656fvj"
    else throw "Bittorrent Sync for: ${stdenv.system} not supported!";

  libPath = stdenv.lib.makeLibraryPath [ stdenv.gcc.libc ];
in
stdenv.mkDerivation rec {
  name = "btsync-${version}";
  version = "1.3.93";

  src  = fetchurl {
    url  = "http://syncapp.bittorrent.com/${version}/btsync_${arch}-${version}.tar.gz";
    inherit sha256;
  };

  dontStrip   = true; # Don't strip, otherwise patching the rpaths breaks
  sourceRoot  = ".";
  buildInputs = [ patchelf ];

  installPhase = ''
    ensureDir "$out/bin/"
    cp -r "btsync" "$out/bin/"

    patchelf --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
      --set-rpath ${libPath} "$out/bin/btsync"
  '';

  meta = {
    description = "Automatically sync files via secure, distributed technology";
    homepage    = "http://www.bittorrent.com/sync";
    license     = stdenv.lib.licenses.unfreeRedistributable;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ iElectric thoughtpolice ];
  };
}
