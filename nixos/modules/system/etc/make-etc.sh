source $stdenv/setup

mkdir -p $out/etc

set -f
sources_=($sources)
targets_=($targets)
modes_=($modes)
users_=($users)
groups_=($groups)
set +f

# Create relative symlinks, so that the links can be followed if
# the NixOS installation is not mounted as filesystem root.
# Absolute symlinks violate the os-release format
# at https://www.freedesktop.org/software/systemd/man/os-release.html
# and break e.g. systemd-nspawn and os-prober.
for ((i = 0; i < ${#targets_[@]}; i++)); do
    source="${sources_[$i]}"
    target="${targets_[$i]}"

    if [[ "$source" =~ '*' ]]; then

        # If the source name contains '*', perform globbing.
        mkdir -p $out/etc/$target
        for fn in $source; do
            ln -s --relative "$fn" $out/etc/$target/
        done

    else

        mkdir -p $out/etc/$(dirname $target)
        if ! [ -e $out/etc/$target ]; then
            ln -s --relative $source $out/etc/$target
        else
            echo "duplicate entry $target -> $source"
            if test "$(readlink $out/etc/$target)" != "$source"; then
                echo "mismatched duplicate entry $(readlink $out/etc/$target) <-> $source"
                exit 1
            fi
        fi

        if test "${modes_[$i]}" != symlink; then
            echo "${modes_[$i]}"  > $out/etc/$target.mode
            echo "${users_[$i]}"  > $out/etc/$target.uid
            echo "${groups_[$i]}" > $out/etc/$target.gid
        fi

    fi
done

