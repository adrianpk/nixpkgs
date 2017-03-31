args @ { fetchurl, ... }:
rec {
  baseName = ''clack'';
  version = ''20170227-git'';

  description = ''Web application environment for Common Lisp'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clack/2017-02-27/clack-20170227-git.tgz'';
    sha256 = ''1sm6iamghpzmrv0h375y2famdngx62ml5dw424896kixxfyr923x'';
  };

  overrides = x: {
  };
}
