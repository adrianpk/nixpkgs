#!/usr/bin/env bash

# Usage: download kde release to $dir, then run
# $0 $dir

dir="$1"

# Detect release number & whether it is a stable release
if [[ ! -d "${dir}" ]]; then
  echo "${dir} is not a directory (or doesn't exist)!" >&2
  exit 1
fi

release=$(ls "${dir}"/kdelibs-*.tar.bz2 | \
  sed -e 's/.*kdelibs-//' -e 's/\.tar\.bz2//')

if [[ ${release##*.} -gt 50 ]]; then
  stable="false"
else
  stable="true"
fi

echo "Detected release ${release}" >&2

declare -A hash
declare -A modules
declare -a packages
declare -a top_level

# xsltproc output declares -A module
if [[ ! -f kde_projects.xml ]]; then
  curl -O -J http://projects.kde.org/kde_projects.xml
fi
eval `xsltproc kde-submodules.xslt kde_projects.xml`

print_sane() {
  echo "Called print_sane $1" >&2
  sane="${1//[^a-z0-9_]/_}"
  if [[ "$sane" != "$1" ]]; then
    echo "Sane version is $sane" >&2
    echo -n "sane=\"$sane\";"
  fi
}

for i in `cd "${dir}"; ls *-${release}.tar.bz2`; do
  package=${i%-${release}.tar.bz2}
  packages+=( "$package" )
  echo -n "${package}.. " >&2
  hash[$package]=$(nix-hash --type sha256 --flat --base32 "${dir}/${i}")
  echo -n ${hash[$package]} >&2

  if [ -n "${module[$package]}" ]; then
    m="${module[$package]}"
    echo " (${m})" >&2
    modules[$m]=1
  else
    top_level+=( "$package" )
    echo " (top-level)" >&2
  fi
  #nix-store --add-fixed sha256 "${dir}/${i}" >&2
done


print_pkg_hash() {
  echo -n "{name=\"${1}\";value=\"${hash[$1]}\";}"
}

print_hashes(){
  echo -n "hashes=builtins.listToAttrs["
  for p in "${packages[@]}"; do print_pkg_hash "$p"; done
  echo -n "];"
}

print_split_module(){
  echo -n "$1:" >&2
  echo -n "{module=\"$1\";"
  print_sane "$1"
  echo -n "split=true;"
  echo -n "pkgs=["
  for p in "${packages[@]}"; do
    if [[ "${module[$p]}" == "$1" ]]; then
      echo -n "{name=\"$p\";"
      print_sane "$p"
      echo -n "}"
      echo -n " $p" >&2
    fi
  done
  echo -n "];}"
  echo >&2
}

print_mono_module(){
  echo -n "{module=\"$1\";"
  print_sane "$1"
  echo -n "$1 ... " >&2
  echo -n "split=false;"
  cml="$1-$release/CMakeLists.txt"
  tar -xf "${dir}/$1-${release}.tar.bz2" "$cml"
  if grep '^[^#]*add_subdirectory' $cml >/dev/null; then
    if grep '^[^#]*add_subdirectory' $cml | grep -v macro_optional_add_subdirectory >/dev/null; then
      echo " is monolithic (has unconditionally added subdirs)" >&2
    else
      subdirs=( `grep '^[^#]*add_subdirectory' $cml |
        sed -e 's/[^#]*add_subdirectory *( *\(.*\) *)/\1/' |
        grep -v '\(doc\|cmake\)'` )
      echo " seems splittable, subdirs: ${subdirs[*]}" >&2
      echo -n "pkgs=["
      for s in "${subdirs[@]}"; do
        echo -n "{name=\"${s//\//-}\";"
        print_sane "$s"
        if [[ $s != "${s//\//-}" ]]; then
          echo -n "subdir=\"$s\";"
        fi
        echo -n "}"
      done
    echo -n "];"
    fi
  else
    echo " is monolithic (has no subdirs)" >&2
  fi
  rm $cml
  rmdir $1-$release
  echo -n "}"
}

print_modules(){
  echo -n "modules=["
  echo "Printing modules splitted by upstream" >&2
  for m in "${!modules[@]}"; do print_split_module "$m"; done
  echo >&2
  echo "Printing modules not splitted by upstream (${top_level[*]})" >&2
  for m in "${top_level[@]}"; do print_mono_module "$m"; done
  echo -n "];"
}

echo "Writing ${release}.nix" >&2
exec > "${release}.nix"
echo -n "{stable=${stable};"
print_hashes
print_modules
echo -n "}"
