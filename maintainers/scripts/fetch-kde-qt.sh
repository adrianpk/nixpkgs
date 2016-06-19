#! /usr/bin/env nix-shell
#! nix-shell -i bash -p coreutils findutils gnused nix wget

tmp=$(mktemp -d)
pushd $tmp >/dev/null
wget -nH -r -c --no-parent "$@" >/dev/null

csv=$(mktemp)
find . -type f | while read src; do
    # Sanitize file name
    filename=$(basename "$src" | tr '@' '_')
    nameVersion="${filename%.tar.*}"
    name=$(echo "$nameVersion" | sed -e 's,-[[:digit:]].*,,' | sed -e 's,-opensource-src$,,')
    version=$(echo "$nameVersion" | sed -e 's,^\([[:alpha:]][[:alnum:]]*-\)\+,,')
    echo "$name,$version,$src,$filename" >>$csv
done

cat <<EOF
# DO NOT EDIT! This file is generated automatically by fetchsrcs.sh
{ fetchurl, mirror }:

{
EOF

gawk -F , "{ print \$1 }" $csv | sort | uniq | while read name; do
    versions=$(gawk -F , "/^$name,/ { print \$2 }" $csv)
    latestVersion=$(echo "$versions" | sort -rV | head -n 1)
    src=$(gawk -F , "/^$name,$latestVersion,/ { print \$3 }" $csv)
    filename=$(gawk -F , "/^$name,$latestVersion,/ { print \$4 }" $csv)
    url="${src:2}"
    sha256=$(nix-hash --type sha256 --base32 --flat "$src")
    cat <<EOF
  $name = {
    version = "$latestVersion";
    src = fetchurl {
      url = "\${mirror}/$url";
      sha256 = "$sha256";
      name = "$filename";
    };
  };
EOF
done

echo "}"

popd >/dev/null
rm -fr $tmp >/dev/null

rm -f $csv >/dev/null
