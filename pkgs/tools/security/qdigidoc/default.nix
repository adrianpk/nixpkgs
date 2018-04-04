{ stdenv, fetchurl, cmake, ccid, qttools, qttranslations, pkgconfig, pcsclite
, hicolor-icon-theme, libdigidocpp, opensc, shared-mime-info, openldap
, gettext, desktop-file-utils, makeWrapper }:

stdenv.mkDerivation rec {

  version = "3.12.0.1442";
  name = "qdigidoc-${version}";

  src = fetchurl {
    url = "https://installer.id.ee/media/ubuntu/pool/main/q/qdigidoc/qdigidoc_3.12.0.1442.orig.tar.xz";
    sha256 = "1a7nsi28q57ic99hrb6x83qlvpqvzvk6acbfl6ncny2j4yaxa4jl";
  };

  patches = [ ./glibc-2_26.patch ];

  unpackPhase = ''
    mkdir src
    tar xf $src -C src
    cd src
  '';

  postInstall = ''
    wrapProgram $out/bin/qdigidocclient \
      --prefix LD_LIBRARY_PATH : ${opensc}/lib/pkcs11/
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake ccid qttools pcsclite qttranslations
                  hicolor-icon-theme libdigidocpp opensc shared-mime-info
                  openldap gettext desktop-file-utils makeWrapper
                ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Qt based UI application for verifying and signing digital signatures";
    homepage = http://www.id.ee/;
    license = licenses.lgpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.jagajaga ];
  };
}
