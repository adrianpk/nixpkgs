{ stdenv, fetchFromGitHub, pantheon, pkgconfig, meson, python3, ninja, vala
, desktop-file-utils, gettext, libxml2, gtk3, granite, libgee, bamf, libcanberra
, libcanberra-gtk3, gnome-desktop, mutter, clutter, plank, gobject-introspection
, elementary-icon-theme, elementary-settings-daemon, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "gala";
  version = "unstable-2018-12-16";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = "7f1e392e03000df0bd47e7832bb3adab81f39ae5";
    sha256 = "1syqq0xfyg5nbnnmy0wp5d66k1bvq9qn27lvr37abxxqig9acpc8";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = pname;
      versionPolicy = "master";
    };
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    gobject-introspection
    libxml2
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    bamf
    clutter
    elementary-icon-theme
    gnome-desktop
    elementary-settings-daemon
    granite
    gtk3
    libcanberra
    libcanberra-gtk3
    libgee
    mutter
    plank
  ];

  patches = [ ./plugins-dir.patch ];

  postPatch = ''
    chmod +x build-aux/meson/post_install.py
    patchShebangs build-aux/meson/post_install.py
  '';

  meta =  with stdenv.lib; {
    description = "A window & compositing manager based on mutter and designed by elementary for use with Pantheon";
    homepage = https://github.com/elementary/gala;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
