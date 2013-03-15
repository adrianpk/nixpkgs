{ stdenv, fetchurl }:

let
  driverdb = fetchurl {
    url = "http://smartmontools.svn.sourceforge.net/viewvc/smartmontools/trunk/smartmontools/drivedb.h?revision=3781";
    sha256 = "0m39ji2kf80dsws5ksg2pmkpn8x00lrlvl5nlc6ldjfss7sjvc9x";
    name = "smartmontools-drivedb.h";
  };
in
stdenv.mkDerivation rec {
  name = "smartmontools-6.0";

  src = fetchurl {
    url = "mirror://sourceforge/smartmontools/${name}.tar.gz";
    sha256 = "9fe4ff2b7bcd00fde19db82bba168f5462ed6e857d3ef439495e304e3231d3a6";
  };

  patchPhase = ''
    cp ${driverdb} drivedb.h
    sed -i -e 's@which which >/dev/null || exit 1@alias which="type -p"@' update-smart-drivedb.in
  '';

  meta = {
    description = "Tools for monitoring the health of hard drivers";
    homepage = "http://smartmontools.sourceforge.net/";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
