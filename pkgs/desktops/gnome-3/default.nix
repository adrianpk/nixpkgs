{ callPackage, self, pkgs }:

rec {
  inherit (pkgs) glib gtk2 gtk3 gnome2;
  gtk = gtk3; # just to be sure
  libcanberra = pkgs.libcanberra_gtk3; # just to be sure
  inherit (pkgs.gnome2) ORBit2;
  orbit = ORBit2;
  inherit (pkgs) libsoup;

#### Core (http://ftp.acc.umu.se/pub/GNOME/core/)

  at_spi2_atk = callPackage ./core/at-spi2-atk { };

  at_spi2_core = callPackage ./core/at-spi2-core { };

  baobab = callPackage ./core/baobab { };

  caribou = callPackage ./core/caribou { };

  dconf = callPackage ./core/dconf { };

  empathy = callPackage ./core/empathy { };

  epiphany = callPackage ./core/epiphany { };

  evince = callPackage ./core/evince { }; # ToDo: dbus would prevent compilation, enable tests

  evolution_data_server = callPackage ./core/evolution-data-server { };

  gconf = callPackage ./core/gconf { };

  geocode_glib = callPackage ./core/geocode-glib { };

  gcr = callPackage ./core/gcr { }; # ToDo: tests fail

  gdm = callPackage ./core/gdm { };

  gjs = callPackage ./core/gjs { };

  gnome-backgrounds = callPackage ./core/gnome-backgrounds { };

  gnome-contacts = callPackage ./core/gnome-contacts { };

  gnome_control_center = callPackage ./core/gnome-control-center { };

  gnome-calculator = callPackage ./core/gnome-calculator { };

  gnome_common = callPackage ./core/gnome-common { };

  gnome-dictionary = callPackage ./core/gnome-dictionary { };

  gnome-disk-utility = callPackage ./core/gnome-disk-utility { };

  gnome-font-viewer = callPackage ./core/gnome-font-viewer { };

  gnome_icon_theme = callPackage ./core/gnome-icon-theme { };

  gnome_icon_theme_symbolic = callPackage ./core/gnome-icon-theme-symbolic { };

  gnome-menus = callPackage ./core/gnome-menus { };

  gnome_keyring = callPackage ./core/gnome-keyring { };

  libgnome_keyring = callPackage ./core/libgnome-keyring { };

  libgnomekbd = callPackage ./core/libgnomekbd { };

  folks = callPackage ./core/folks { };

  gnome_online_accounts = callPackage ./core/gnome-online-accounts { };

  gnome_session = callPackage ./core/gnome-session { };

  gnome_shell = callPackage ./core/gnome-shell { };

  gnome-shell-extensions = callPackage ./core/gnome-shell-extensions { };

  gnome-screenshot = callPackage ./core/gnome-screenshot { };

  gnome_settings_daemon = callPackage ./core/gnome-settings-daemon { };

  gnome-system-log = callPackage ./core/gnome-system-log { };

  gnome-system-monitor = callPackage ./core/gnome-system-monitor { };

  gnome_terminal = callPackage ./core/gnome-terminal { };

  gnome_themes_standard = callPackage ./core/gnome-themes-standard { };

  gnome-user-docs = callPackage ./core/gnome-user-docs { };

  gnome-user-share = callPackage ./core/gnome-user-share { };

  grilo = callPackage ./core/grilo { };

  gsettings_desktop_schemas = callPackage ./core/gsettings-desktop-schemas { };

  gtksourceview = callPackage ./core/gtksourceview { };

  gucharmap = callPackage ./core/gucharmap { };

  gvfs = pkgs.gvfs.override { gnome = pkgs.gnome3; };

  eog = callPackage ./core/eog { };

  libcroco = callPackage ./core/libcroco {};

  libgee = callPackage ./core/libgee { };

  libgdata = callPackage ./core/libgdata { };

  libgxps = callPackage ./core/libgxps { };

  libpeas = callPackage ./core/libpeas {};

  libgweather = callPackage ./core/libgweather { };

  libzapojit = callPackage ./core/libzapojit { };

  mutter = callPackage ./core/mutter { };

  nautilus = callPackage ./core/nautilus { };

  rest = callPackage ./core/rest { };

  sushi = callPackage ./core/sushi { };

  totem = callPackage ./core/totem { };

  totem-pl-parser = callPackage ./core/totem-pl-parser { };

  tracker = callPackage ./core/tracker { };

  vte = callPackage ./core/vte { };

  vino = callPackage ./core/vino { };

  yelp = callPackage ./core/yelp { };

  yelp_xsl = callPackage ./core/yelp-xsl { };

  yelp_tools = callPackage ./core/yelp-tools { };

  zenity = callPackage ./core/zenity { };


#### Apps (http://ftp.acc.umu.se/pub/GNOME/apps/)

  file-roller = callPackage ./apps/file-roller { };

  gedit = callPackage ./apps/gedit { };

  gnome_desktop = callPackage ./desktop/gnome-desktop { };


  # scrollkeeper replacement
  rarian = callPackage ./desktop/rarian { };


#### Misc -- other packages on http://ftp.gnome.org/pub/GNOME/sources/

  goffice = callPackage ./misc/goffice { };

  gitg = callPackage ./misc/gitg { };

  libgit2-glib = callPackage ./misc/libgit2-glib { };
  
  gexiv2 = callPackage ./misc/gexiv2 { };

  gnome-tweak-tool = callPackage ./misc/gnome-tweak-tool { };
}
