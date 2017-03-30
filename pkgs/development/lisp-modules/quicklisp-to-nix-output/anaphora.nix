args @ { fetchurl, ... }:
rec {
  baseName = ''anaphora'';
  version = ''20170227-git'';

  description = ''The Anaphoric Macro Package from Hell'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/anaphora/2017-02-27/anaphora-20170227-git.tgz'';
    sha256 = ''1inv6bcly6r7yixj1pp0i4h0y7lxyv68mk9wsi5iwi9gx6000yd9'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :anaphora)"' "$out/bin/anaphora-lisp-launcher.sh" ""
    '';
  };
}
