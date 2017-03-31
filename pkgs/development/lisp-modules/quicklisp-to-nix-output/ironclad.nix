args @ { fetchurl, ... }:
rec {
  baseName = ''ironclad'';
  version = ''ironclad_0.33.0'';

  description = ''A cryptographic toolkit written in pure Common Lisp'';

  deps = [ args."nibbles" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/ironclad/2014-11-06/ironclad_0.33.0.tgz'';
    sha256 = ''1ld0xz8gmi566zxl1cva5yi86aw1wb6i6446gxxdw1lisxx3xwz7'';
  };

  overrides = x: {
  };
}
