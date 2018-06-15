{ stdenv
, fetchFromGitHub
, autoreconfHook
, pkgconfig
, boost
, m4ri
, gd
}:

stdenv.mkDerivation rec {
  version = "1.2.3";
  name = "brial-${version}";

  src = fetchFromGitHub {
    owner = "BRiAl";
    repo = "BRiAl";
    rev = version;
    sha256 = "0qy4cwy7qrk4zg151cmws5cglaa866z461cnj9wdnalabs7v7qbg";
  };

  # FIXME package boost-test and enable checks
  doCheck = false;

  configureFlags = [
    "--with-boost-unit-test-framework=no"
  ];

  buildInputs = [
    boost
    m4ri
    gd
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/BRiAl/BRiAl;
    description = "Legacy version of PolyBoRi maintained by sagemath developers";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ timokau ];
    platforms = platforms.linux;
  };
}
