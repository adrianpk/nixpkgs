{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "rclone-${version}";
  version = "1.45";

  goPackagePath = "github.com/ncw/rclone";
  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "ncw";
    repo = "rclone";
    rev = "v${version}";
    sha256 = "06xg0ibv9pnrnmabh1kblvxx1pk8h5rmkr9mjbymv497sx3zgz26";
  };

  outputs = [ "bin" "out" "man" ];

  postInstall = ''
    install -D -m644 $src/rclone.1 $man/share/man/man1/rclone.1
  '';

  meta = with stdenv.lib; {
    description = "Command line program to sync files and directories to and from major cloud storage";
    homepage = https://rclone.org;
    license = licenses.mit;
    maintainers = with maintainers; [ danielfullmer ];
    platforms = platforms.all;
  };
}
