{ pkgs, stdenv, lib, bundler, fetchurl, fetchFromGitHub, bundlerEnv, libiconv
, ruby, tzdata, git, procps, dpkg, nettools
}:

/* When updating the Gemfile add `gem "activerecord-nulldb-adapter"`
   to allow building the assets without a database */

let
  rubyEnv = bundlerEnv {
    name = "gitlab-env-${version}";
    inherit ruby;
    gemdir = ./.;
    meta = with lib; {
      homepage = http://www.gitlab.com/;
      platforms = platforms.linux;
      maintainers = with maintainers; [ fpletz globin ];
      license = licenses.mit;
    };
  };

  version = "10.5.4";

  gitlabDeb = fetchurl {
    url = "https://packages.gitlab.com/gitlab/gitlab-ce/packages/debian/jessie/gitlab-ce_${version}-ce.0_amd64.deb/download";
    sha256 = "1fsz2rdfcb1a2a2jwl8009r8ldi1rg8rj07751lgwy52jdp1ihka";
  };

in

stdenv.mkDerivation rec {
  name = "gitlab-${version}";

  src = fetchFromGitHub {
    owner = "gitlabhq";
    repo = "gitlabhq";
    rev = "v${version}";
    sha256 = "1glvqzbspaw88nwmgpxvkz52a4pz3wp3h5xs1f9kc32k2vh384nz";
  };

  buildInputs = [
    rubyEnv ruby bundler tzdata git procps dpkg nettools
  ];

  patches = [
    ./remove-hardcoded-locations.patch
    ./nulladapter.patch
    ./fix-36783.patch
  ];

  postPatch = ''
    # For reasons I don't understand "bundle exec" ignores the
    # RAILS_ENV causing tests to be executed that fail because we're
    # not installing development and test gems above. Deleting the
    # tests works though.:
    rm lib/tasks/test.rake

    rm config/initializers/gitlab_shell_secret_token.rb

    substituteInPlace app/controllers/admin/background_jobs_controller.rb \
        --replace "ps -U" "${procps}/bin/ps -U"

    # required for some gems:
    cat > config/database.yml <<EOF
      production:
        adapter: <%= ENV["GITLAB_DATABASE_ADAPTER"] || sqlite %>
        database: gitlab
        host: <%= ENV["GITLAB_DATABASE_HOST"] || "127.0.0.1" %>
        password: <%= ENV["GITLAB_DATABASE_PASSWORD"] || "blerg" %>
        username: gitlab
        encoding: utf8
    EOF
  '';

  buildPhase = ''
    mv config/gitlab.yml.example config/gitlab.yml

    # work around unpacking deb containing binary with suid bit
    ar p ${gitlabDeb} data.tar.gz | gunzip > gitlab-deb-data.tar
    tar -f gitlab-deb-data.tar --delete ./opt/gitlab/embedded/bin/ksu
    tar -xf gitlab-deb-data.tar

    mv -v opt/gitlab/embedded/service/gitlab-rails/public/assets public
    rm -rf opt

    mv config/gitlab.yml config/gitlab.yml.example
    rm -f config/secrets.yml
    mv config config.dist
  '';

  installPhase = ''
    rm -r tmp
    mkdir -p $out/share
    cp -r . $out/share/gitlab
    rm -rf $out/share/gitlab/log
    ln -sf /run/gitlab/log $out/share/gitlab/log
    ln -sf /run/gitlab/uploads $out/share/gitlab/public/uploads
    ln -sf /run/gitlab/config $out/share/gitlab/config
    ln -sf /run/gitlab/tmp $out/share/gitlab/tmp

    # rake tasks to mitigate CVE-2017-0882
    # see https://about.gitlab.com/2017/03/20/gitlab-8-dot-17-dot-4-security-release/
    cp ${./reset_token.rake} $out/share/gitlab/lib/tasks/reset_token.rake
  '';

  passthru = {
    inherit rubyEnv;
    inherit ruby;
  };
}
