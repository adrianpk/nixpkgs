{stdenv, fetchurl, freetype, expat}:

stdenv.mkDerivation rec {
  name = "fontconfig-2.7.3";
  
  src = fetchurl {
    url = "http://fontconfig.org/release/${name}.tar.gz";
    sha256 = "0l5hjifapv4v88a204ixg6w6xly81cji2cr65znra0vbbkqvz3xs";
  };
  
  buildInputs = [freetype];
  propagatedBuildInputs = [expat]; # !!! shouldn't be necessary, but otherwise pango breaks

  configureFlags = "--with-confdir=/etc/fonts --with-cache-dir=/var/cache/fontconfig --disable-docs --with-default-fonts=";

  # We should find a better way to access the arch reliably.
  crossArch = if (stdenv ? cross && stdenv.cross != null)
    then stdenv.cross.arch else null;


  preConfigure = ''
    if test -n "$crossConfig"; then
      configureFlags="$configureFlags --with-arch=$crossArch";
    fi
  '';

  # Don't try to write to /etc/fonts or /var/cache/fontconfig at install time.
  installFlags = "CONFDIR=$(out)/etc/fonts RUN_FC_CACHE_TEST=false fc_cachedir=$(TMPDIR)/dummy";

  meta = {
    description = "A library for font customization and configuration";
    homepage = http://fontconfig.org/;
    license = "bsd";
  };  
}
