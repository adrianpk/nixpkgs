{ stdenv, fetchFromGitHub, fetchpatch, python3, meson, ninja, vala, pkgconfig, gobject-introspection, libgee, pantheon, gtk3, glib, gettext, hicolor-icon-theme, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "granite";
  version = "5.2.3";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "10ddq1s2w4jvpzq813cylmqhh8pggzaz890fy3kzg07275i98gah";
  };

  patches = [
    # Resolve the circular dependency between granite and the datetime wingpanel indicator
    # See: https://github.com/elementary/granite/pull/242
    ./02-datetime-clock-format-gsettings.patch
  ];

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = pname;
    };
  };

  nativeBuildInputs = [
    gettext
    gobject-introspection
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk3
    hicolor-icon-theme
    libgee
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "An extension to GTK+ used by elementary OS";
    longDescription = ''
      Granite is a companion library for GTK+ and GLib. Among other things, it provides complex widgets and convenience functions
      designed for use in apps built for elementary OS.
    '';
    homepage = https://github.com/elementary/granite;
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
