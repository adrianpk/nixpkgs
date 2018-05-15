{ stdenv, fetchurl, fetchpatch, flite, alsaLib, debug ? false }:

stdenv.mkDerivation rec {
  name = "eflite-${version}";
  version = "0.4.1";

  src = fetchurl {
    url = "https://sourceforge.net/projects/eflite/files/eflite/${version}/${name}.tar.gz";
    sha256 = "088p9w816s02s64grfs28gai3lnibzdjb9d1jwxzr8smbs2qbbci";
  };

  buildInputs = [ flite alsaLib ];

  configureFlags = [
    "flite_dir=${flite}"
    "--with-audio=alsa"
    "--with-vox=cmu_us_kal16"
  ];

  patches = [
    (fetchpatch {
      url = "https://sources.debian.org/data/main/e/eflite/0.4.1-8/debian/patches/cvs-update";
      sha256 = "0r631vzmky7b7qyhm152557y4fr0xqrpi3y4w66fcn6p4rj03j05";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/e/eflite/0.4.1-8/debian/patches/buf-overflow";
      sha256 = "071qk133kb7n7bq6kxgh3p9bba6hcl1ixsn4lx8vp8klijgrvkmx";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/e/eflite/0.4.1-8/debian/patches/link";
      sha256 = "0p833dp4pdsya72bwh3syvkq85927pm6snxvx13lvcppisbhj0fc";
    })
    ./format.patch
  ];

  CFLAGS = stdenv.lib.optionalString debug " -DDEBUG=2";

  meta = {
    homepage = http://eflite.sourceforge.net;
    description = "EFlite is a speech server for screen readers";
    longDescription = ''
      EFlite is a speech server for Emacspeak and other screen
      readers that allows them to interface with Festival Lite,
      a free text-to-speech engine developed at the CMU Speech
      Center as an off-shoot of Festival.
    '';
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ jhhuh ];
  };
}
