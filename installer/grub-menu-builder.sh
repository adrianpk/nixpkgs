#! @bash@/bin/sh -e

shopt -s nullglob

export PATH=/empty
for i in @path@; do PATH=$PATH:$i/bin; done

default=$1
if test -z "$1"; then
    echo "Syntax: grub-menu-builder.sh <DEFAULT-CONFIG>"
    exit 1
fi


target=/boot/grub/menu.lst
tmp=$target.tmp

cat > $tmp << GRUBEND
# Automatically generated.  DO NOT EDIT THIS FILE!
default=0
timeout=5
GRUBEND



addEntry() {
    local name="$1"
    local path="$2"
    local shortSuffix="$3"

    if ! test -e $path/kernel -a -e $path/initrd; then
        return
    fi

    local kernel=$(readlink -f $path/kernel)
    local initrd=$(readlink -f $path/initrd)

    if test -n "@copyKernels@"; then
        local kernel2=/boot/kernels/$(echo $kernel | sed 's^/^-^g')
        if ! test -e $kernel2; then
            cp $kernel $kernel2
        fi
        kernel=$kernel2

        local initrd2=/boot/kernels/$(echo $initrd | sed 's^/^-^g')
        if ! test -e $initrd2; then
            cp $initrd $initrd2
        fi
        initrd=$initrd2

        if test -n "@bootMount@"; then
          kernel=$(echo $kernel2 | sed -e 's^/boot^@bootMount@^')
          initrd=$(echo $initrd2 | sed -e 's^/boot^@bootMount@^')
        fi
    fi
    
    local confName=$(if test -e $path/configuration-name; then 
	cat $path/configuration-name; 
    fi);
    if test -n "$confName" ; then
	name="$confName $3";
    fi;

    cat >> $tmp << GRUBEND
title $name
  kernel $kernel systemConfig=$(readlink -f $path) init=$(readlink -f $path/init) $(cat $path/kernel-params)
  initrd $initrd
GRUBEND
}


rm -rf /boot/kernels
if test -n "@copyKernels@"; then
    mkdir -p /boot/kernels
fi


if test -n "$tmp"; then
    addEntry "NixOS - Default" $default ""
fi


# Additional entries specified verbatim by the configuration.
cat >> $tmp <<EOF

@extraGrubEntries@

EOF


# Add all generations of the system profile to the menu, in reverse
# (most recent to least recent) order.
for link in $((ls -d $default/fine-tune/* ) | sort -n); do
    date=$(stat --printf="%y\n" $link | sed 's/\..*//')
    addEntry "NixOS - variation" $link ""
done
for generation in $(
    (cd /nix/var/nix/profiles && ls -d system-*-link) \
    | sed 's/system-\([0-9]\+\)-link/\1/' \
    | sort -n -r); do
    echo $generation
    link=/nix/var/nix/profiles/system-$generation-link
    date=$(stat --printf="%y\n" $link | sed 's/\..*//')
    addEntry "NixOS - Configuration $generation ($date)" $link "$generation ($date)"
done


cp $tmp $target
