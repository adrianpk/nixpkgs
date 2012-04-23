#! @bash@/bin/sh -e

shopt -s nullglob

export PATH=/empty
for i in @path@; do PATH=$PATH:$i/bin; done

if test $# -ne 1; then
    echo "Usage: grub-menu-builder.sh DEFAULT-CONFIG"
    exit 1
fi

grubVersion="@version@"
defaultConfig="$1"

case "$grubVersion" in
    1|2)
	echo "updating GRUB $grubVersion menu..."
	;;
    *)
	echo "Unsupported GRUB version \`$grubVersion'" >&2
	echo "Supported versions are \`1' (GRUB Legacy) and \`2' (GRUB 1.9x)." >&2
	exit 1
	;;
esac


# Discover whether /boot is on the same filesystem as / and
# /nix/store.  If not, then all kernels and initrds must be copied to
# /boot, and all paths in the GRUB config file must be relative to the
# root of the /boot filesystem.  `$bootRoot' is the path to be
# prepended to paths under /boot.
if [ "$(stat -c '%D' /.)" != "$(stat -c '%D' /boot/.)" ]; then
    bootRoot=
    copyKernels=1
elif [ "$(stat -c '%D' /boot/.)" != "$(stat -c '%D' /nix/store/.)" ]; then
    bootRoot=/boot
    copyKernels=1
else
    bootRoot=/boot
    copyKernels="@copyKernels@" # user can override in the NixOS config
fi


prologue() {
    case "$grubVersion" in
	1)
	    cat > "$1" << GRUBEND
# Automatically generated.  DO NOT EDIT THIS FILE!
default @default@
timeout @timeout@
GRUBEND
	    if [ -n "@splashImage@" ]; then
                cp -f "@splashImage@" /boot/background.xpm.gz
                echo "splashimage $bootRoot/background.xpm.gz" >> "$1"
            fi
	    ;;
	2)
            cp -f @grub@/share/grub/unicode.pf2 /boot/grub/unicode.pf2
	    cat > "$1" <<EOF
# Automatically generated.  DO NOT EDIT THIS FILE!

if [ -s \$prefix/grubenv ]; then
  load_env
fi

# ‘grub-reboot’ sets a one-time saved entry, which we process here and
# then delete.
if [ "\${saved_entry}" ]; then
  # The next line *has* to look exactly like this, otherwise KDM's
  # reboot feature won't work properly with GRUB 2.
  set default="\${saved_entry}"
  set saved_entry=
  set prev_saved_entry=
  save_env saved_entry
  save_env prev_saved_entry
  set timeout=1
else
  set default=@default@
  set timeout=@timeout@
fi

if loadfont $bootRoot/grub/unicode.pf2; then
  set gfxmode=640x480
  insmod gfxterm
  insmod vbe
  terminal_output gfxterm
fi
EOF
	    if test -n "@splashImage@"; then
                cp -f "@splashImage@" /boot/background.png
		# FIXME: GRUB 1.97 doesn't resize the background image
		# if it doesn't match the video resolution.
		cat >> "$1" <<EOF
insmod png
if background_image $bootRoot/background.png; then
  set color_normal=white/black
  set color_highlight=black/white
else
  set menu_color_normal=cyan/blue
  set menu_color_highlight=white/blue
fi
EOF
	    fi
	    ;;
    esac
}

case "$grubVersion" in
    1) target="/boot/grub/menu.lst";;
    2) target="/boot/grub/grub.cfg";;
esac

tmp="$target.tmp"

prologue "$tmp"


configurationCounter=0
configurationLimit="@configurationLimit@"
numAlienEntries=`cat <<EOF | egrep '^[[:space:]]*title' | wc -l
@extraEntries@
EOF`

if test $((configurationLimit+numAlienEntries)) -gt 190; then
    configurationLimit=$((190-numAlienEntries));
fi


# Convert a path to a file in the Nix store such as
# /nix/store/<hash>-<name>/file to <hash>-<name>-<file>.
cleanName() {
    local path="$1"
    echo "$path" | sed 's|^/nix/store/||' | sed 's|/|-|g'
}


# Copy a file from the Nix store to /boot/kernels.
declare -A filesCopied

copyToKernelsDir() {
    local src="$1"
    local p="kernels/$(cleanName $src)"
    local dst="/boot/$p"
    # Don't copy the file if $dst already exists.  This means that we
    # have to create $dst atomically to prevent partially copied
    # kernels or initrd if this script is ever interrupted.
    if ! test -e $dst; then
        local dstTmp=$dst.tmp.$$
        cp "$src" "$dstTmp"
        mv $dstTmp $dst
    fi
    filesCopied[$dst]=1
    result="$bootRoot/$p"
}


# Add an entry for a configuration to the Grub menu, and if
# appropriate, copy its kernel and initrd to /boot/kernels.
addEntry() {
    local name="$1"
    local path="$2"
    local shortSuffix="$3"

    configurationCounter=$((configurationCounter + 1))
    if test $configurationCounter -gt @configurationLimit@; then
	return
    fi

    if ! test -e $path/kernel -a -e $path/initrd; then
        return
    fi

    local kernel=$(readlink -f $path/kernel)
    local initrd=$(readlink -f $path/initrd)
    local xen=$([ -f $path/xen.gz ] && readlink -f $path/xen.gz)

    if test "$path" = "$defaultConfig"; then
	cp "$kernel" /boot/nixos-kernel
	cp "$initrd" /boot/nixos-initrd
	cp "$(readlink -f "$path/init")" /boot/nixos-init
	case "$grubVersion" in
	    1)
		cat > /boot/nixos-grub-config <<EOF
title Emergency boot
  kernel $bootRoot/nixos-kernel systemConfig=$(readlink -f "$path") init=/boot/nixos-init $(cat "$path/kernel-params")
  initrd $bootRoot/nixos-initrd
EOF
		;;
	    2)
		cat > /boot/nixos-grub-config <<EOF
menuentry "Emergency boot" {
  linux  $bootRoot/nixos-kernel systemConfig=$(readlink -f "$path") init=/boot/nixos-init $(cat "$path/kernel-params")
  initrd $bootRoot/nixos-initrd
}
EOF
		;;
	esac
    fi

    if test -n "$copyKernels"; then
        copyToKernelsDir $kernel; kernel=$result
        copyToKernelsDir $initrd; initrd=$result
        if [ -n "$xen" ]; then copyToKernelsDir $xen; xen=$result; fi
    fi

    local confName=$(cat $path/configuration-name 2>/dev/null || true)
    if test -n "$confName"; then
	name="$confName $3"
    fi

    local kernelParams="systemConfig=$(readlink -f $path) init=$(readlink -f $path/init) $(cat $path/kernel-params)"
    local xenParams="$([ -n "$xen" ] && cat $path/xen-params)"

    case "$grubVersion" in
	1)
	    cat >> "$tmp" << GRUBEND
title $name
  @extraPerEntryConfig@
  ${xen:+kernel $xen $xenParams}
  $(if [ -z "$xen" ]; then echo kernel; else echo module; fi) $kernel $kernelParams
  $(if [ -z "$xen" ]; then echo initrd; else echo module; fi) $initrd
GRUBEND
	    ;;
	2)
	    cat >> "$tmp" << GRUBEND
menuentry "$name" {
  @extraPerEntryConfig@
  ${xen:+multiboot $xen $xenParams}
  $(if [ -z "$xen" ]; then echo linux; else echo module; fi) $kernel $kernelParams
  $(if [ -z "$xen" ]; then echo initrd; else echo module; fi) $initrd
}
GRUBEND
	    ;;
    esac
}


if test -n "$copyKernels"; then
    mkdir -p /boot/kernels
fi

@extraPrepareConfig@

# Additional entries specified verbatim by the configuration.
extraEntries=`cat <<EOF
@extraEntries@
EOF`


cat >> $tmp <<EOF
@extraConfig@
EOF

if test -n "@extraEntriesBeforeNixOS@"; then 
    echo "$extraEntries" >> $tmp
fi

addEntry "NixOS - Default" $defaultConfig ""

if test -z "@extraEntriesBeforeNixOS@"; then 
    echo "$extraEntries" >> $tmp
fi

# Add all generations of the system profile to the menu, in reverse
# (most recent to least recent) order.
for link in $((ls -d $defaultConfig/fine-tune/* ) | sort -n); do
    date=$(stat --printf="%y\n" $link | sed 's/\..*//')
    addEntry "NixOS - variation" $link ""
done

if [ "$grubVersion" = 2 ]; then
    cat >> $tmp <<EOF
submenu "NixOS - Old configurations" {
EOF
fi

for generation in $(
    (cd /nix/var/nix/profiles && for i in system-*-link; do echo $i; done) \
    | sed 's/system-\([0-9]\+\)-link/\1/' \
    | sort -n -r); do
    link=/nix/var/nix/profiles/system-$generation-link
    date=$(stat --printf="%y\n" $link | sed 's/\..*//' | sed 's/ .*//')
    kernelVersion=$(cd $(dirname $(readlink -f $link/kernel))/lib/modules && echo *)
    nixosVersion=$(if [ -e $link/nixos-version ]; then cat $link/nixos-version; fi)
    addEntry "NixOS - Configuration $generation ($date - ${nixosVersion:-$kernelVersion})" $link "$generation ($date)"
done

if [ "$grubVersion" = 2 ]; then
    cat >> $tmp <<EOF
}
EOF
fi


# Atomically update the GRUB configuration file.
mv $tmp $target


# Remove obsolete files from /boot/kernels.
for fn in /boot/kernels/*; do
    if ! test "${filesCopied[$fn]}" = 1; then
        rm -vf -- "$fn"
    fi
done
