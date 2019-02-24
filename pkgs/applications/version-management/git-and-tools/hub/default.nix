{ stdenv, buildGoPackage, fetchFromGitHub, ronn, ruby, groff, Security, utillinux, git, glibcLocales }:

buildGoPackage rec {
  pname = "hub";
  version = "2.10.0";

  goPackagePath = "github.com/github/hub";

  # Only needed to build the man-pages
  excludedPackages = [ "github.com/github/hub/md2roff-bin" ];

  src = fetchFromGitHub {
    owner = "github";
    repo = pname;
    rev = "v${version}";
    sha256 = "1vvrc3k81jm9c664g0j9666i7ypn7n7jfyj4gxcybq3sg2d4di27";
  };

  nativeBuildInputs = [ groff ronn utillinux glibcLocales ];
  buildInputs = [ ruby ] ++
    stdenv.lib.optional stdenv.isDarwin Security;

  postPatch = ''
    patchShebangs .
  '';

  postInstall = ''
    cd go/src/${goPackagePath}
    install -D etc/hub.zsh_completion "$bin/share/zsh/site-functions/_hub"
    install -D etc/hub.bash_completion.sh "$bin/share/bash-completion/completions/hub"
    install -D etc/hub.fish_completion  "$bin/share/fish/vendor_completions.d/hub.fish"

    PATH=$PATH:${git}/bin LC_ALL=en_US.utf-8 make man-pages
    cp -vr --parents share/man/man[1-9]/*.[1-9] $bin/
  '';

  meta = with stdenv.lib; {
    description = "Command-line wrapper for git that makes you better at GitHub";
    license = licenses.mit;
    homepage = https://hub.github.com/;
    maintainers = with maintainers; [ the-kenny ];
    platforms = with platforms; unix;
  };
}
