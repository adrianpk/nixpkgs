#!/bin/sh

if [ $# -ne 1 ]
then
    echo "Usage: $(basename $0) VERSION"
    echo
    echo "Download and GPG-check component tarballs for GCC VERSION."
    exit 1
fi

version="$1"

set -e

out="sources.nix"

declare -A options

options["core"]="/* langC */ true"
options["g++"]="langCC"
options["fortran"]="langFortran"
options["java"]="langJava"
options["ada"]="langAda"
options["go"]="langGo"

cat > "$out"<<EOF
/* Automatically generated by \`$(basename $0)', do not edit.
   For GCC ${version}.  */
{ fetchurl, optional, version, langC, langCC, langFortran, langJava, langAda,
  langGo }:

assert version == "${version}";
EOF

for component in core g++ fortran java ada go
do
    dir="ftp.gnu.org/gnu/gcc/gcc-${version}"
    file="gcc-${component}-${version}.tar.bz2"
    url="${dir}/${file}"

    rm -f "${file}"

    wget "$url"
    hash="$(nix-hash --flat --type sha256 "$file")"
    path="$(nix-store --add-fixed sha256 "$file")"

    rm -f "${file}" "${file}.sig"
    wget "${url}.sig"
    gpg --verify "${file}.sig" "${path}" || gpg2 --verify "${file}.sig" "${path}"
    rm "${file}.sig"

    cat >> "$out" <<EOF
optional ${options[$component]} (fetchurl {
  url = "mirror://gcc/releases/gcc-\${version}/gcc-${component}-\${version}.tar.bz2";
  sha256 = "${hash}";
}) ++
EOF
done

cat >> "$out" <<EOF
[]
EOF

echo "result stored in \`$out'"
