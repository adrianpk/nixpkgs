{ stdenv, lib, fetchFromGitHub }: with lib; stdenv.mkDerivation rec {
  name = "icingaweb2-theme-spring";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Mikesch-mp";
    repo = name;
    rev = "v${version}";
    sha256 = "09v4871pndarhm2spxm9fdab58l5wj8m40kh53wvk1xc3g7pqki9";
  };

  installPhase = ''
    mkdir -p "$out"
    cp -r * "$out"
  '';

  meta = {
    description = "Theme with some soft colors and nice background images loaded from unsplash.com";
    homepage = "https://github.com/Mikesch-mp/icingaweb2-theme-spring";
    license = licenses.publicDomain;
    platforms = platforms.all;
    maintainers = with maintainers; [ das_j ];
  };
}
