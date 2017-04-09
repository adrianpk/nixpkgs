NIX_LISP_ASDF="@out@"

CL_SOURCE_REGISTRY="${CL_SOURCE_REGISTRY:+$CL_SOURCE_REGISTRY:}@out@/lib/common-lisp/asdf/"

addASDFPaths () {
    for j in "$1"/lib/common-lisp-settings/*-path-config.sh; do
      source "$j"
    done
}

setLisp () {
    if [ -z "$NIX_LISP_COMMAND" ]; then 
      for j in "$1"/bin/*; do
          case "$(basename "$j")" in
              sbcl) NIX_LISP_COMMAND="$j" ;;
              ecl) NIX_LISP_COMMAND="$j" ;;
              clisp) NIX_LISP_COMMAND="$j" ;;
          esac
      done
    fi
    if [ -z "$NIX_LISP" ]; then 
        NIX_LISP="${NIX_LISP_COMMAND##*/}"
    fi
}

collectNixLispLDLP () {
     if echo "$1/lib"/lib*.so* | grep . > /dev/null; then
	 export NIX_LISP_LD_LIBRARY_PATH="$NIX_LISP_LD_LIBRARY_PATH${NIX_LISP_LD_LIBRARY_PATH:+:}$1/lib"
     fi
}

export NIX_LISP_COMMAND NIX_LISP CL_SOURCE_REGISTRY NIX_LISP_ASDF

envHooks+=(addASDFPaths setLisp collectNixLispLDLP)

mkdir -p "$HOME"/.cache/common-lisp || HOME="$TMP/.temp-$USER-home"
mkdir -p "$HOME"/.cache/common-lisp
