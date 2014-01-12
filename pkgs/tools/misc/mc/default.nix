{ stdenv, fetchurl, pkgconfig, glib, gpm, file, e2fsprogs
, libX11, libICE, perl, zip, unzip, gettext, slang}:

stdenv.mkDerivation rec {
  name = "mc-4.8.11";
  
  src = fetchurl {
    url = http://www.midnight-commander.org/downloads/mc-4.8.11.tar.bz2;
    sha256 = "1yjm6rp9h3491mar7vdw88mgvydmz7zdj97mmjkqyf5bidx4w2hf";
  };
  
  buildInputs = [ pkgconfig perl glib gpm slang zip unzip file gettext libX11 libICE e2fsprogs ];

  meta = {
    description = "File Manager and User Shell for the GNU Project";
    homepage = http://www.midnight-commander.org;
    license = "GPLv2+";
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
