source $stdenv/setup

ensureDir $out

ln -s $kernel $out/kernel
ln -s $grub $out/grub

cat > $out/menu.lst << GRUBEND
# Automatically generated.  DO NOT EDIT THIS FILE!
default=0
timeout=5
title NixOS
        kernel $kernel selinux=0 apm=on acpi=on
        initrd $initrd
GRUBEND

ensureDir $out/bin

cat > $out/bin/switch-to-configuration <<EOF
#! $SHELL
set -e
export PATH=$coreutils/bin:$gnused/bin:$gnugrep/bin:$diffutils/bin
if test -n "$grubDevice"; then
    $grub/sbin/grub-install "$grubDevice" --no-floppy --recheck
    cp -f $out/menu.lst /boot/grub/menu.lst
fi
EOF

chmod +x $out/bin/switch-to-configuration
