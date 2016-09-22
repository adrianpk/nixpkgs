{ stdenv, fetchurl, fetchpatch, runCommand, zlib }:

let ccache = stdenv.mkDerivation rec {
  name = "ccache-${version}";
  version = "3.2.5";

  src = fetchurl {
    sha256 = "11db1g109g0g5si0s50yd99ja5f8j4asxb081clvx78r9d9i2w0i";
    url = "mirror://samba/ccache/${name}.tar.xz";
  };

  buildInputs = [ zlib ];

  postPatch = ''
    substituteInPlace Makefile.in --replace 'objs) $(extra_libs)' 'objs)'
  '';

  doCheck = !stdenv.isDarwin;

  passthru = let
      unwrappedCC = stdenv.cc.cc;
    in {
    # A derivation that provides gcc and g++ commands, but that
    # will end up calling ccache for the given cacheDir
    links = extraConfig: stdenv.mkDerivation rec {
      name = "ccache-links";
      passthru = {
        isClang = unwrappedCC.isClang or false;
        isGNU = unwrappedCC.isGNU or false;
      };
      inherit (unwrappedCC) lib;
      buildCommand = ''
        mkdir -p $out/bin

        wrap() {
          local cname="$1"
          if [ -x "${unwrappedCC}/bin/$cname" ]; then
            cat > $out/bin/$cname << EOF
        #!/bin/sh
        ${extraConfig}
        exec ${ccache}/bin/ccache ${unwrappedCC}/bin/$cname "\$@"
        EOF
            chmod +x $out/bin/$cname
          fi
        }

        wrap cc
        wrap c++
        wrap gcc
        wrap g++
        wrap clang
        wrap clang++

        for executable in $(ls ${unwrappedCC}/bin); do
          if [ ! -x "$out/bin/$executable" ]; then
            ln -s ${unwrappedCC}/bin/$executable $out/bin/$executable
          fi
        done
        for file in $(ls ${unwrappedCC} | grep -vw bin); do
          ln -s ${unwrappedCC}/$file $out/$file
        done
      '';
    };
  };

  meta = with stdenv.lib; {
    description = "Compiler cache for fast recompilation of C/C++ code";
    homepage = http://ccache.samba.org/;
    downloadPage = https://ccache.samba.org/download.html;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ nckx ];
    platforms = platforms.unix;
  };
};
in ccache
