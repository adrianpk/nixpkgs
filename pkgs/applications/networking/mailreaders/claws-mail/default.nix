{ fetchurl, stdenv, wrapGAppsHook
, curl, dbus, dbus_glib, enchant, gtk, gnutls, gnupg, gpgme, hicolor_icon_theme
, libarchive, libcanberra, libetpan, libnotify, libsoup, libxml2, networkmanager
, openldap , perl, pkgconfig, poppler, python, shared_mime_info, webkitgtk2
, glib_networking, gsettings_desktop_schemas

# Build options
# TODO: A flag to build the manual.
# TODO: Plugins that complain about their missing dependencies, even when
#       provided:
#         gdata requires libgdata
#         geolocation requires libchamplain
#         python requires python
, enableLdap ? false
, enableNetworkManager ? false
, enablePgp ? false
, enablePluginArchive ? false
, enablePluginFancy ? false
, enablePluginNotificationDialogs ? true
, enablePluginNotificationSounds ? true
, enablePluginPdf ? false
, enablePluginRavatar ? false
, enablePluginRssyl ? false
, enablePluginSmime ? false
, enablePluginSpamassassin ? false
, enablePluginSpamReport ? false
, enablePluginVcalendar ? false
, enableSpellcheck ? false
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "claws-mail-${version}";
  version = "3.13.2";

  meta = {
    description = "The user-friendly, lightweight, and fast email client";
    homepage = http://www.claws-mail.org/;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.khumba ];
    priority = 10;  # Resolve the conflict with the share/mime link we create.
  };

  src = fetchurl {
    url = "http://www.claws-mail.org/download.php?file=releases/claws-mail-${version}.tar.xz";
    sha256 = "1l8ankx0qpq1ix1an8viphcf11ksh53jsrm1xjmq8cjbh5910wva";
  };

  patches = [ ./mime.patch ];

  buildInputs =
    [ curl dbus dbus_glib gtk gnutls gsettings_desktop_schemas hicolor_icon_theme
      libetpan perl pkgconfig python wrapGAppsHook
    ]
    ++ optional enableSpellcheck enchant
    ++ optionals (enablePgp || enablePluginSmime) [ gnupg gpgme ]
    ++ optional enablePluginArchive libarchive
    ++ optional enablePluginNotificationSounds libcanberra
    ++ optional enablePluginNotificationDialogs libnotify
    ++ optional enablePluginFancy libsoup
    ++ optional enablePluginRssyl libxml2
    ++ optional enableNetworkManager networkmanager
    ++ optional enableLdap openldap
    ++ optional enablePluginPdf poppler
    ++ optional enablePluginFancy webkitgtk2;

  configureFlags =
    optional (!enableLdap) "--disable-ldap"
    ++ optional (!enableNetworkManager) "--disable-networkmanager"
    ++ optionals (!enablePgp) [
      "--disable-pgpcore-plugin"
      "--disable-pgpinline-plugin"
      "--disable-pgpmime-plugin"
    ]
    ++ optional (!enablePluginArchive) "--disable-archive-plugin"
    ++ optional (!enablePluginFancy) "--disable-fancy-plugin"
    ++ optional (!enablePluginPdf) "--disable-pdf_viewer-plugin"
    ++ optional (!enablePluginRavatar) "--disable-libravatar-plugin"
    ++ optional (!enablePluginRssyl) "--disable-rssyl-plugin"
    ++ optional (!enablePluginSmime) "--disable-smime-plugin"
    ++ optional (!enablePluginSpamassassin) "--disable-spamassassin-plugin"
    ++ optional (!enablePluginSpamReport) "--disable-spam_report-plugin"
    ++ optional (!enablePluginVcalendar) "--disable-vcalendar-plugin"
    ++ optional (!enableSpellcheck) "--disable-enchant";

  wrapPrefixVariables = [ "GIO_EXTRA_MODULES" ];
  GIO_EXTRA_MODULES = "${glib_networking}/lib/gio/modules";

  postInstall = ''
    mkdir -p $out/share/applications
    cp claws-mail.desktop $out/share/applications

    ln -sT ${shared_mime_info}/share/mime $out/share/mime
  '';
}
