source $stdenv/setup

tagtext=""
tagflags=""
if test -n "$tag"; then
    tagtext="(tag $tag) "
    tagflags="--tag=$tag"
elif test -n "$context"; then
    tagtext="(context) "
    tagflags="--context=$context"
fi

header "getting $url $partial ${tagtext} into $out"

darcs get --lazy --ephemeral $tagflags "$url" "$out"
# remove metadata, because it can change
rm -rf "$out/_darcs"

stopNest
