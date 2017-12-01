{ stdenv, fetchurl, gcc, glibc, m4, coreutils }:

let
  options = rec {
    /* TODO: there are also MacOS, FreeBSD and Windows versions */
    x86_64-linux = {
      arch = "linuxx86";
      sha256 = "0hs1f3z7crgzvinpj990kv9gvbsipxvcvwbmk54n51nasvc5025q";
      runtime = "lx86cl64";
      kernel = "linuxx8664";
    };
    i686-linux = {
      arch = "linuxx86";
      sha256 = x86_64-linux.sha256;
      runtime = "lx86cl";
      kernel = "linuxx8632";
    };
    armv7l-linux = {
      arch = "linuxarm";
      sha256 = "0p0l1dzsygb6i1xxgbipjpxkn46xhq3jm41a34ga1qqp4x8lkr62";
      runtime = "armcl";
      kernel = "linuxarm";
    };
    armv6l-linux = armv7l-linux;
  };
  cfg = options.${stdenv.system};
in

assert builtins.hasAttr stdenv.system options;

stdenv.mkDerivation rec {
  name     = "ccl-${version}";
  version  = "1.11.5";

  src = fetchurl {
    url = "https://github.com/Clozure/ccl/releases/download/v${version}/ccl-${version}-${cfg.arch}.tar.gz";
    sha256 = cfg.sha256;
  };

  buildInputs = [ gcc glibc m4 ];

  CCL_RUNTIME = cfg.runtime;
  CCL_KERNEL = cfg.kernel;

  postPatch = ''
    substituteInPlace lisp-kernel/${CCL_KERNEL}/Makefile \
      --replace "/bin/rm"    "${coreutils}/bin/rm" \
      --replace "/bin/echo"  "${coreutils}/bin/echo"

    substituteInPlace lisp-kernel/m4macros.m4 \
      --replace "/bin/pwd" "${coreutils}/bin/pwd"
  '';

  buildPhase = ''
    make -C lisp-kernel/${CCL_KERNEL} clean
    make -C lisp-kernel/${CCL_KERNEL} all

    ./${CCL_RUNTIME} -n -b -e '(ccl:rebuild-ccl :full t)' -e '(ccl:quit)'
  '';

  installPhase = ''
    mkdir -p "$out/share"
    cp -r .  "$out/share/ccl-installation"

    mkdir -p "$out/bin"
    echo -e '#!/bin/sh\n'"$out/share/ccl-installation/${CCL_RUNTIME}"' "$@"\n' > "$out"/bin/"${CCL_RUNTIME}"
    chmod a+x "$out"/bin/"${CCL_RUNTIME}"
    ln -s "$out"/bin/"${CCL_RUNTIME}" "$out"/bin/ccl
  '';

  meta = with stdenv.lib; {
    description = "Clozure Common Lisp";
    homepage    = https://ccl.clozure.com/;
    maintainers = with maintainers; [ raskin muflax tohl ];
    platforms   = attrNames options;
    license     = licenses.lgpl21;
  };
}
