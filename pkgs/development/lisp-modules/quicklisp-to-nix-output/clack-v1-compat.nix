args @ { fetchurl, ... }:
rec {
  baseName = ''clack-v1-compat'';
  version = ''clack-20170516-git'';

  description = '''';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clack/2017-05-16/clack-20170516-git.tgz'';
    sha256 = ''1161lsv739z02ijp0p95cb3vbybqhffp03sipb7l1vmmj24d8wgw'';
  };
    
  packageName = "clack-v1-compat";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/clack-v1-compat[.]asd${"$"}' |
        while read f; do
          env -i \
          NIX_LISP="$NIX_LISP" \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(progn
            (asdf:load-system :$(basename "$f" .asd))
            (asdf:perform (quote asdf:compile-bundle-op) :$(basename "$f" .asd))
            (ignore-errors (asdf:perform (quote asdf:deliver-asd-op) :$(basename "$f" .asd)))
            )'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM clack-v1-compat DESCRIPTION NIL SHA256 1161lsv739z02ijp0p95cb3vbybqhffp03sipb7l1vmmj24d8wgw URL
    http://beta.quicklisp.org/archive/clack/2017-05-16/clack-20170516-git.tgz MD5 ecda950881158c3bf209b29f4717fb0a NAME clack-v1-compat TESTNAME NIL FILENAME
    clack-v1-compat DEPS NIL DEPENDENCIES NIL VERSION clack-20170516-git SIBLINGS
    (clack-handler-fcgi clack-handler-hunchentoot clack-handler-toot clack-handler-wookie clack-socket clack-test clack t-clack-handler-fcgi
     t-clack-handler-hunchentoot t-clack-handler-toot t-clack-handler-wookie t-clack-v1-compat clack-middleware-auth-basic clack-middleware-clsql
     clack-middleware-csrf clack-middleware-dbi clack-middleware-oauth clack-middleware-postmodern clack-middleware-rucksack clack-session-store-dbi
     t-clack-middleware-auth-basic t-clack-middleware-csrf)) */
