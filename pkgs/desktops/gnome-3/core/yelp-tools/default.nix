{ stdenv, fetchurl, libxml2, libxslt, itstool, gnome3, pkgconfig }:

stdenv.mkDerivation rec {
  name = "yelp-tools-${version}";
  version = "3.28.0";

  src = fetchurl {
    url = "mirror://gnome/sources/yelp-tools/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1b61dmlb1sd50fgq6zgnkcpx2s1py33q0x9cx67fzpsr4gmgxnw2";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "yelp-tools"; attrPath = "gnome3.yelp-tools"; };
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libxml2 libxslt itstool gnome3.yelp-xsl ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Yelp/Tools;
    description = "Small programs that help you create, edit, manage, and publish your Mallard or DocBook documentation";
    maintainers = with maintainers; [ domenkozar ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
