{ lib, callPackage, stdenv, overrideCC, gcc5, fetchurl, fetchFromGitHub, fetchpatch }:

let

  common = opts: callPackage (import ./common.nix opts);

  nixpkgsPatches = [
    ./env_var_for_system_dir.patch

    # this one is actually an omnipresent bug
    # https://bugzilla.mozilla.org/show_bug.cgi?id=1444519
    ./fix-pa-context-connect-retval.patch
  ];

in

rec {

  firefox = common rec {
    pname = "firefox";
    version = "59.0.3";
    src = fetchurl {
      url = "https://hg.mozilla.org/releases/mozilla-release/archive/6b51784853e47e091d213d421a19cb623af718f0.tar.bz2";
      sha512 = "2dh2hp307iz90969i8r96hdmd0d2v2d5zjp0n3klsn789sd6b3jdznb4mc5ghpm2rpcl48rqakw6apvmhidcahc1zbc1fq6j6a86jqp";
    };

    patches = nixpkgsPatches ++ [
      ./no-buildconfig.patch
    ];

    meta = {
      description = "A web browser built from Firefox source tree";
      homepage = http://www.mozilla.com/en-US/firefox/;
      maintainers = with lib.maintainers; [ eelco ];
      platforms = lib.platforms.linux;
    };
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-unwrapped";
    };
  } {};

  firefox-esr = common rec {
    pname = "firefox-esr";
    version = "52.7.4esr";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "971ac97a749e5d322fec95ca1e86af5b633deab37d2d8fb49ab129c7ba20753a802c620315bc5b92a0a7ab7afe00e71aca04b3238670c4732d8e6816c645f53a";
    };

    patches = nixpkgsPatches
    # The following patch is only required on ARM platforms and should be
    # included for the next ESR release >= 52.7.3esr
    ++ lib.optional stdenv.isAarch32
      (fetchpatch {
        name = "CVE-2018-5147-tremor.patch";
        url = https://hg.mozilla.org/releases/mozilla-esr52/rev/5cd5586a2f48;
        sha256 = "0mdqa9w1p6cmli6976v4wi0sw9r4p5prkj7lzfd1877wk11c9c73";
      })
    ;

    meta = firefox.meta // {
      description = "A web browser built from Firefox Extended Support Release source tree";
    };
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-esr-unwrapped";
      versionSuffix = "esr";
    };
  } {};

} // (let

  commonAttrs = {
    overrides = {
      unpackPhase = ''
        # fetchFromGitHub produces ro sources, root dir gets a name that
        # is too long for shebangs. fixing
        cp -a $src tor-browser
        chmod -R +w tor-browser
        cd tor-browser

        # set times for xpi archives
        find . -exec touch -d'2010-01-01 00:00' {} \;
      '';
    };

    meta = {
      description = "A web browser built from TorBrowser source tree";
      longDescription = ''
        This is a version of TorBrowser with bundle-related patches
        reverted.

        I.e. it's a variant of Firefox with less fingerprinting and
        some isolation features you can't get with any extensions.

        Or, alternatively, a variant of TorBrowser that works like any
        other UNIX program and doesn't expect you to run it from a
        bundle.

        It will use your default Firefox profile if you're not careful
        even! Be careful!

        It will clash with firefox binary if you install both. But its
        not a problem since you should run browsers in separate
        users/VMs anyway.

        Create new profile by starting it as

        $ firefox -ProfileManager

        and then configure it to use your tor instance.
      '';
      homepage = https://www.torproject.org/projects/torbrowser.html;
      platforms = lib.platforms.linux;
    };
  };

in rec {

  tor-browser-7-0 = common (rec {
    pname = "tor-browser";
    version = "7.0.1";
    isTorBrowserLike = true;

    # FIXME: fetchFromGitHub is not ideal, unpacked source is >900Mb
    src = fetchFromGitHub {
      owner = "SLNOS";
      repo  = "tor-browser";
      # branch "tor-browser-52.5.0esr-7.0-1-slnos";
      rev   = "830ff8d622ef20345d83f386174f790b0fc2440d";
      sha256 = "169mjkr0bp80yv9nzza7kay7y2k03lpnx71h4ybcv9ygxgzdgax5";
    };

    patches = nixpkgsPatches;
  } // commonAttrs) {};

  tor-browser-7-5 = common (rec {
    pname = "tor-browser";
    version = "7.5.2";
    isTorBrowserLike = true;

    # FIXME: fetchFromGitHub is not ideal, unpacked source is >900Mb
    src = fetchFromGitHub {
      owner = "SLNOS";
      repo  = "tor-browser";
      # branch "tor-browser-52.6.2esr-7.5-2-slnos";
      rev   = "cf1a504aaa26af962ae909a3811c0038db2d2eec";
      sha256 = "0llbk7skh1n7yj137gv7rnxfasxsnvfjp4ss7h1fbdnw19yba115";
    };

    patches = nixpkgsPatches;
  } // commonAttrs) {};

  tor-browser = tor-browser-7-5;

})
