{ stdenv, lib, fetchurl, perl, pkgconfig, systemd, openssl
, bzip2, zlib, lz4, inotify-tools, pam, libcap
, clucene_core_2, icu, openldap, libsodium, libstemmer, cyrus_sasl
, nixosTests
# Auth modules
, withMySQL ? false, mysql
, withPgSQL ? false, postgresql
, withSQLite ? true, sqlite
}:

stdenv.mkDerivation rec {
  name = "dovecot-2.3.4";

  nativeBuildInputs = [ perl pkgconfig ];
  buildInputs =
    [ openssl bzip2 zlib lz4 clucene_core_2 icu openldap libsodium libstemmer cyrus_sasl.dev ]
    ++ lib.optionals (stdenv.isLinux) [ systemd pam libcap inotify-tools ]
    ++ lib.optional withMySQL mysql.connector-c
    ++ lib.optional withPgSQL postgresql
    ++ lib.optional withSQLite sqlite;

  src = fetchurl {
    url = "https://dovecot.org/releases/2.3/${name}.tar.gz";
    sha256 = "01ggzf7b3jpl89mjiqr7xbpbs181g2gjf6wzg70qaqfzz3ppc6yr";
  };

  preConfigure = ''
    patchShebangs src/config/settings-get.pl
  '';

  # We need this for sysconfdir, see remark below.
  installFlags = [ "DESTDIR=$(out)" ];

  postInstall = ''
    cp -r $out/$out/* $out
    rm -rf $out/$(echo "$out" | cut -d "/" -f2)
  '';

  patches = [
    # Make dovecot look for plugins in /etc/dovecot/modules
    # so we can symlink plugins from several packages there.
    # The symlinking needs to be done in NixOS.
    ./2.2.x-module_dir.patch
  ];

  configureFlags = [
    # It will hardcode this for /var/lib/dovecot.
    # http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=626211
    "--localstatedir=/var"
    # We need this so utilities default to reading /etc/dovecot/dovecot.conf file.
    "--sysconfdir=/etc"
    "--with-ldap"
    "--with-ssl=openssl"
    "--with-zlib"
    "--with-bzlib"
    "--with-lz4"
    "--with-ldap"
    "--with-lucene"
    "--with-icu"
  ] ++ lib.optional (stdenv.isLinux) "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
    ++ lib.optional (stdenv.isDarwin) "--enable-static"
    ++ lib.optional withMySQL "--with-mysql"
    ++ lib.optional withPgSQL "--with-pgsql"
    ++ lib.optional withSQLite "--with-sqlite";

  meta = {
    homepage = https://dovecot.org/;
    description = "Open source IMAP and POP3 email server written with security primarily in mind";
    maintainers = with stdenv.lib.maintainers; [ peti rickynils fpletz ];
    platforms = stdenv.lib.platforms.unix;
  };
  passthru.tests = {
    opensmtpd-interaction = nixosTests.opensmtpd;
  };
}
