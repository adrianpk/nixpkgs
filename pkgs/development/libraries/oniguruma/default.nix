{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "onig-${version}";
  version = "6.8.2";

  src = fetchFromGitHub {
    owner = "kkos";
    repo = "oniguruma";
    rev = "v${version}";
    sha256 = "00ly5i26n7wajhyhq3xadsc7dxrf7qllhwilk8dza2qj5dhld4nd";
  };

  nativeBuildInputs = [ cmake ];

  prePatch = stdenv.lib.optional stdenv.isDarwin ''
    substituteInPlace cmake/dist.cmake \
      --replace '@executable_path/''${UP_DIR}/''${INSTALL_LIB}' $out'/''${INSTALL_LIB}'
  '';

  meta = {
    homepage = https://github.com/kkos/oniguruma;
    description = "Regular expressions library";
    license = stdenv.lib.licenses.bsd2;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
    platforms = with stdenv.lib.platforms; unix;
  };
}
