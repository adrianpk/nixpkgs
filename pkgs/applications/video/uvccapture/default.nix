{ stdenv, fetchurl, libjpeg }:

let
  debianPatches = fetchurl {
    url = "mirror://debian/pool/main/u/uvccapture/uvccapture_0.5-3.debian.tar.gz";
    sha256 = "0m29by13nw1r8sch366qzdxg5rsd1k766kqg1nj2pdb8f7pwjh9r";
  };

in

stdenv.mkDerivation rec {
  name = "uvccapture-0.5";
  
  src = fetchurl {
    url = "mirror://debian/pool/main/u/uvccapture/uvccapture_0.5.orig.tar.gz";
    sha256 = "1b3akkcmr3brbf93akr8xi20w8zqf2g0qfq928500wy04qi6jqpi";
  };

  buildInputs = [ libjpeg ];

  patchPhase = ''
    tar xvf "${debianPatches}"
    for fname in debian/patches/fix_videodev_include_FTBFS.patch \
                 debian/patches/warnings.patch \
                 debian/patches/numbuffers.patch
    do
        echo "Applying patch $fname"
        patch < "$fname"
    done
  '';

  makeFlagsArray = [ "PREFIX=$(out)/bin/" ];

  preInstall = ''
    mkdir -p "$out/bin"
  '';

  # Upstream has no man page, install one from Debian
  postInstall = ''
    mkdir -p "$out/share/man/man1"
    cp -v debian/uvccapture.1 "$out/share/man/man1/"
  '';

  meta = with stdenv.lib; {
    description = "Capture image from USB webcam at a specified interval";
    homepage = http://linux-uvc.berlios.de/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
