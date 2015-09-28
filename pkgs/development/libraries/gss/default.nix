{ stdenv, fetchurl

# Optional Dependencies
, shishi ? null
}:

stdenv.mkDerivation rec {
  name = "gss-1.0.3";

  src = fetchurl {
    url = "mirror://gnu/gss/${name}.tar.gz";
    sha256 = "1syyvh3k659xf1hdv9pilnnhbbhs6vfapayp4xgdcc8mfgf9v4gz";
  };

  buildInputs = [ shishi ];

  configureFlags = [
    "--${if shishi != null then "enable" else "disable"}-kereberos5"
  ];

  doCheck = true;

  # Fixup .la files
  postInstall = stdenv.lib.optionalString (!stdenv.isDarwin && shishi != null) ''
    sed -i 's,\(-lshishi\),-L${shishi}/lib \1,' $out/lib/libgss.la
  '';

  meta = with stdenv.lib; {
    homepage = http://www.gnu.org/software/gss/;
    description = "Generic Security Service";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ bjg wkennington ];
    platforms = platforms.all;
  };
}
