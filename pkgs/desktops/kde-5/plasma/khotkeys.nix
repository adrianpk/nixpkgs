{ plasmaPackage, ecm, kdoctools, kcmutils
, kdbusaddons, kdelibs4support, kglobalaccel, ki18n, kio, kxmlgui
, plasma-framework, plasma-workspace, qtx11extras
, fetchpatch
}:

plasmaPackage {
  name = "khotkeys";
  nativeBuildInputs = [ ecm kdoctools ];

  patches = [
    # Patch is in 5.9 and up.
    (fetchpatch {
      url = "https://cgit.kde.org/khotkeys.git/patch/?id=f8f7eaaf41e2b95ebfa4b2e35c6ee252524a471b";
      sha256 = "1jpd9zwrvp7pwv6v5cx6aqr2p1zhismpig7xv71wfxi7skfh3389";
    })
  ];
  propagatedBuildInputs = [
    kdelibs4support kglobalaccel ki18n kio plasma-framework plasma-workspace
    qtx11extras kcmutils kdbusaddons kxmlgui
  ];
}
