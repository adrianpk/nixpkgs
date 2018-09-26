{ lib, bundlerEnv, ruby, buildGoPackage, fetchFromGitHub }:
let
  # needed for manpage generation
  gems = bundlerEnv {
    name = "ejson-gems";
    gemdir = ./.;
    inherit ruby;
  };
in buildGoPackage rec {
  name = "ejson-${version}";
  version = "1.2.0";
  rev = "v${version}";

  nativeBuildInputs = [ gems ];

  goPackagePath = "github.com/Shopify/ejson";
  subPackages = [ "cmd/ejson" ];

  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = "ejson";
    inherit rev;
    sha256 = "07ig24fryb9n0mfyqb0sgpj7di9y7wbvh2ppwfs2jqfpvpncd7yh";
  };

  # set HOME, otherwise bundler will insert stuff in the manpages
  postBuild = ''
    cd go/src/$goPackagePath
    HOME=$PWD make man
  '';

  postInstall = ''
    mkdir -p $out/share
    cp -r build/man $out/share
  '';

  meta = with lib; {
    description = "A small library to manage encrypted secrets using asymmetric encryption.";
    license = licenses.mit;
    homepage = https://github.com/Shopify/ejson;
    platforms = platforms.unix;
    maintainers = [ maintainers.manveru ];
  };
}
