#!/bin/sh

prog=$0

usage(){
  echo 1>&2 "
$prog module-dir

This script generates the `module-list.nix' index file inside the
module directory.
"
  exit 1
}

: ${NIXPKGS=/etc/nixos/nixpkgs}

is_module(){
  local file=$1
  echo "
    let
      appIfFun = f: x: if builtins.isFunction f then f x else f;
    in
      builtins.isAttrs (
        appIfFun (import $file) {
          pkgs = (import $NIXPKGS) {};
          config = {};
          dummy = 42;
        }
      )
  " | nix-instantiate - --eval-only
}

generate_index(){
  local path="$1"
  cd "$path"
  echo -n "$path: " 1>&2
  { echo "[ # This file has been generated by $(basename $prog)";
    for file in : $(find ./ -wholename '*.impl[./]*' -or -wholename './module-list.nix' -or -type f -name '*.nix' -print | sort); do
       [ "$file" = ':' ] && continue;
       echo -n . 1>&2
       if test "$(is_module "$file" 2> /dev/null)" = "Bool(True)"; then
         echo "  $file"
       else
         echo "##### $file"
         is_module "$file" 2>&1 | sed 's/^/# /'
       fi
    done
    echo ']';
  } > ./module-list.nix
  echo 1>&2
  cd - > /dev/null
}

[ $# -eq 1 ] || usage;

generate_index "$1"
