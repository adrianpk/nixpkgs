{ stdenv, buildGoPackage, fetchFromGitHub, makeWrapper
, git, bash, gzip, openssh
, sqliteSupport ? true
}:

with stdenv.lib;

buildGoPackage rec {
  name = "gitea-${version}";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "go-gitea";
    repo = "gitea";
    rev = "v${version}";
    sha256 = "168pbndlh7c148p8wzkd39kd7idiba9zw7v0alp9zqcqzzayaydj";
    # Required to generate the same checksum on MacOS due to unicode encoding differences
    # More information: https://github.com/NixOS/nixpkgs/pull/48128
    extraPostFetch = ''
      rm -rf $out/integrations
      rm -rf $out/vendor/github.com/Unknown/cae/tz/testdata
      rm -rf $out/vendor/github.com/Unknown/cae/zip/testdata
      rm -rf $out/vendor/gopkg.in/macaron.v1/fixtures
    '';
  };

  patches = [ ./static-root-path.patch ];

  postPatch = ''
    patchShebangs .
    substituteInPlace modules/setting/setting.go --subst-var data
  '';

  nativeBuildInputs = [ makeWrapper ];

  buildFlags = optionalString sqliteSupport "-tags sqlite";

  outputs = [ "bin" "out" "data" ];

  postInstall = ''
    mkdir $data
    cp -R $src/{public,templates} $data
    mkdir -p $out
    cp -R $src/options/locale $out/locale

    wrapProgram $bin/bin/gitea \
      --prefix PATH : ${makeBinPath [ bash git gzip openssh ]}
  '';

  goPackagePath = "code.gitea.io/gitea";

  meta = {
    description = "Git with a cup of tea";
    homepage = https://gitea.io;
    license = licenses.mit;
    maintainers = [ maintainers.disassembler ];
  };
}
