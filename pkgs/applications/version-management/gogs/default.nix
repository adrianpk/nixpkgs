{ stdenv, buildGoPackage, fetchFromGitHub, makeWrapper
, git, coreutils, bash, gzip, openssh
, sqliteSupport ? true
}:

buildGoPackage rec {
  name = "gogs-${version}";
  version = "0.9.97";

  src = fetchFromGitHub {
    owner = "gogits";
    repo = "gogs";
    rev = "v${version}";
    sha256 = "151mmd8h5zd4bvafd42nsky0m9gblf5fcpd6jacqcrry1796hxk9";
  };

  patchPhase = ''
    substituteInPlace models/repo.go \
      --replace '#!/usr/bin/env' '#!${coreutils}/bin/env'
  '';

  buildInputs = [ makeWrapper ];

  buildFlags = stdenv.lib.optionalString sqliteSupport "-tags sqlite";

  outputs = [ "bin" "out" "data" ];

  postInstall = ''
    mkdir $data
    cp -R $src/{public,templates} $data

    wrapProgram $bin/bin/gogs \
      --prefix PATH : ${stdenv.lib.makeBinPath [ bash git gzip openssh ]} \
      --run 'export GOGS_WORK_DIR=''${GOGS_WORK_DIR:-$PWD}' \
      --run 'mkdir -p "$GOGS_WORK_DIR" && cd "$GOGS_WORK_DIR"' \
      --run "ln -fs $data/{public,templates} ."
  '';

  goPackagePath = "github.com/gogits/gogs";
  goDeps = ./deps.nix;

  meta = {
    description = "A painless self-hosted Git service";
    homepage = "https://gogs.io";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ schneefux ];
  };
}
