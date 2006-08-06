#! /bin/sh -e

# deps is an array
declare -a deps

NIXSTORE=`which nix-store`
NIXINSTANTIATE=`which nix-instantiate`

coreutils=$($NIXSTORE -r $(echo '(import ./pkgs.nix).coreutils' | $NIXINSTANTIATE -))

# determine where we can find the Nix binaries
NIX=$($coreutils/bin/dirname $(which nix-store))

# make sure we use many of our own tools, because it is more pure
mktemp=$($NIX/nix-store -r $(echo '(import ./pkgs.nix).mktemp' | $NIX/nix-instantiate -))

gnused=$($NIX/nix-store -r $(echo '(import ./pkgs.nix).gnused' | $NIX/nix-instantiate -))
gnutar=$($NIX/nix-store -r $(echo '(import ./pkgs.nix).gnutar' | $NIX/nix-instantiate -))
cdrtools=$($NIX/nix-store -r $(echo '(import ./pkgs.nix).cdrtools' | $NIX/nix-instantiate -))
gzip=$($NIX/nix-store -r $(echo '(import ./pkgs.nix).gzip' | $NIX/nix-instantiate -))
cpio=$($NIX/nix-store -r $(echo '(import ./pkgs.nix).cpio' | $NIX/nix-instantiate -))

archivesDir=$($mktemp/bin/mktemp -d)
manifest=${archivesDir}/MANIFEST
nixpkgs=/nixpkgs/trunk/pkgs
fill_disk=$archivesDir/scripts/fill-disk.sh
ramdisk_login=$archivesDir/scripts/ramdisk-login.sh
storePaths=$archivesDir/mystorepaths
narStorePaths=$archivesDir/narstorepaths
validatePaths=$archivesDir/validatepaths
bootiso=/tmp/nixos.iso
initrd=/tmp/initram.img
initdir=${archivesDir}/initdir
initscript=$archivesDir/scripts/init.sh

nix=$($NIX/nix-store -r $(echo '(import ./pkgs.nix).nixUnstable' | $NIX/nix-instantiate -))
busybox=$($NIX/nix-store -r $(echo '(import ./pkgs.nix).busybox' | $NIX/nix-instantiate -))

nixDeps=$($NIX/nix-store -qR $nix)

#storeExpr=$($NIX/nix-store -qR $($NIX/nix-store -r $(echo '(import ./pkgs.nix).everything' | $NIX/nix-instantiate -)))
#storeExpr1=$($NIX/nix-store -r $(echo '(import ./pkgs.nix).boot' | $NIX/nix-instantiate -))
storeExpr=$($NIX/nix-store -r $(echo '(import ./pkgs.nix).boot' | $NIX/nix-instantiate -))
#storeExpr=$($NIX/nix-store -r $($NIX/nix-store -qR $(echo '(import ./pkgs.nix).everything' | $NIX/nix-instantiate -)))

### make NAR files for everything we want to install and some more. Make sure
### the right URL is in there, so specify /cdrom and not cdrom
$NIX/nix-push --copy $archivesDir $manifest --target /cdrom $storeExpr $($NIX/nix-store -r $(echo '(import ./pkgs.nix).kernel' | $NIX/nix-instantiate -))

# Location of sysvinit?
sysvinitPath=$($NIX/nix-store -r $(echo '(import ./pkgs.nix).sysvinit' | $NIX/nix-instantiate -))

# Location of Nix boot scripts?
bootPath=$($NIX/nix-store -r $(echo '(import ./pkgs.nix).boot' | $NIX/nix-instantiate -))

syslinux=$($NIX/nix-store -r $(echo '(import ./pkgs.nix).syslinux' | $NIX/nix-instantiate -))

kernel=$($NIX/nix-store -r $(echo '(import ./pkgs.nix).kernel' | $NIX/nix-instantiate -))

#nixDeps=$($NIX/nix-store -qR $(echo '(import ./pkgs.nix).nix' | $NIX/nix-instantiate -))

utillinux=$($NIX/nix-store -r $(echo '(import ./pkgs.nix).utillinux' | $NIX/nix-instantiate -))

gnugrep=$($NIX/nix-store -r $(echo '(import ./pkgs.nix).gnugrep' | $NIX/nix-instantiate -))

grub=$($NIX/nix-store -r $(echo '(import ./pkgs.nix).grubWrapper' | $NIX/nix-instantiate -))

findutils=$($NIX/nix-store -q $(echo '(import ./pkgs.nix).findutilsWrapper' | $NIX/nix-instantiate -))

#combideps=$($NIX/nix-store -qR $nix $utillinux $gnugrep $grub $gzip $findutils)
combideps=$($NIX/nix-store -qR $nix $busybox $grub $findutils)

for i in $storeExpr
do
  echo $i >> $narStorePaths
done
#for i in $nixDeps
for i in $combideps
do
  echo $i >> $storePaths
  echo '' >> $storePaths
  deps=$($NIX/nix-store -q --references $i)
  pkgs=$(echo $deps | $coreutils/bin/wc -w)
  echo $pkgs >> $storePaths
  for j in $deps
  do
    echo $j >> $storePaths
  done
  echo copying from store: $i
  $gnutar/bin/tar -cf - $i | $gnutar/bin/tar --directory=$archivesDir -xf -
done

tar zcf ${archivesDir}/nixstore.tgz $combideps

utilLinux=$(nix-store -r $(echo '(import ./pkgs.nix).utillinuxStatic' | $NIX/nix-instantiate -))
coreUtilsDiet=$($NIX/nix-store -qR $(nix-store -r $(echo '(import ./pkgs.nix).coreutilsDiet' | $NIX/nix-instantiate -)))

## temporarily normal e2fsprogs until I can get it to build with dietlibc
e2fsProgs=$($NIX/nix-store -qR $(nix-store -r $(echo '(import ./pkgs.nix).e2fsprogsDiet' | $NIX/nix-instantiate -)))
#e2fsProgs=$($NIX/nix-store -qR $(nix-store -r $(echo '(import ./pkgs.nix).e2fsprogs' | $NIX/nix-instantiate -)))
modUtils=$($NIX/nix-store -qR $(nix-store -r $(echo '(import ./pkgs.nix).module_init_toolsStatic' | $NIX/nix-instantiate -)))
Grub=$($NIX/nix-store -qR $(nix-store -r $(echo '(import ./pkgs.nix).grubWrapper' | $NIX/nix-instantiate -)))
Kernel=$($NIX/nix-store -qR $(nix-store -r $(echo '(import ./pkgs.nix).kernel' | $NIX/nix-instantiate -)))
SysVinit=$($NIX/nix-store -qR $(nix-store -r $(echo '(import ./pkgs.nix).sysvinit' | $NIX/nix-instantiate -)))
BootPath=$($NIX/nix-store -qR $(nix-store -r $(echo '(import ./pkgs.nix).boot' | $NIX/nix-instantiate -)))

bashGlibc=$($NIX/nix-store -q $(echo '(import ./pkgs.nix).bash' | $NIX/nix-instantiate -))
bash=$($NIX/nix-store -q $(echo '(import ./pkgs.nix).bashStatic' | $NIX/nix-instantiate -))
coreutilsdiet=$($NIX/nix-store -q $(echo '(import ./pkgs.nix).coreutilsDiet' | $NIX/nix-instantiate -))
#findutils=$($NIX/nix-store -q $(echo '(import ./pkgs.nix).findutilsWrapper' | $NIX/nix-instantiate -))
utillinux=$($NIX/nix-store -q $(echo '(import ./pkgs.nix).utillinux' | $NIX/nix-instantiate -))
e2fsprogs=$($NIX/nix-store -q $(echo '(import ./pkgs.nix).e2fsprogsDiet' | $NIX/nix-instantiate -))
#e2fsprogs=$($NIX/nix-store -q $(echo '(import ./pkgs.nix).e2fsprogs' | $NIX/nix-instantiate -))
#e2fsprogs=$($NIX/nix-store -q $(echo '(import ./pkgs.nix).e2fsprogs' | $NIX/nix-instantiate -))
modutils=$($NIX/nix-store -q $(echo '(import ./pkgs.nix).module_init_toolsStatic' | $NIX/nix-instantiate -))
grub=$($NIX/nix-store -r $(echo '(import ./pkgs.nix).grubWrapper' | $NIX/nix-instantiate -))
mingettyWrapper=$($NIX/nix-store -r $(echo '(import ./pkgs.nix).mingettyWrapper' | $NIX/nix-instantiate -))
dhcp=$($NIX/nix-store -r $(echo '(import ./pkgs.nix).dhcpWrapper' | $NIX/nix-instantiate -))
nano=$($NIX/nix-store -r $(echo '(import ./pkgs.nix).nano' | $NIX/nix-instantiate -))
gnugrep=$($NIX/nix-store -r $(echo '(import ./pkgs.nix).gnugrep' | $NIX/nix-instantiate -))
which=$($NIX/nix-store -r $(echo '(import ./pkgs.nix).which' | $NIX/nix-instantiate -))
eject=$($NIX/nix-store -r $(echo '(import ./pkgs.nix).eject' | $NIX/nix-instantiate -))
sysklogd=$($NIX/nix-store -r $(echo '(import ./pkgs.nix).sysklogd' | $NIX/nix-instantiate -))
#kudzu=$($NIX/nix-store -r $(echo '(import ./pkgs.nix).kudzu' | $NIX/nix-instantiate -))

echo creating directories for bootimage

$coreutils/bin/mkdir ${initdir}
$coreutils/bin/mkdir ${initdir}/bin
$coreutils/bin/mkdir ${initdir}/cdrom
$coreutils/bin/mkdir ${initdir}/dev
$coreutils/bin/mkdir ${initdir}/etc
$coreutils/bin/mkdir ${initdir}/etc/sysconfig
$coreutils/bin/mkdir ${initdir}/installimage
$coreutils/bin/mkdir ${initdir}/modules
$coreutils/bin/mkdir ${initdir}/proc
$coreutils/bin/mkdir ${initdir}/sbin
$coreutils/bin/mkdir ${initdir}/sys
$coreutils/bin/mkdir ${initdir}/tmp
$coreutils/bin/mkdir -p ${initdir}/usr/bin
$coreutils/bin/mkdir -p ${initdir}/usr/sbin
$coreutils/bin/mkdir ${initdir}/var
$coreutils/bin/mkdir ${initdir}/var/run

echo copying nixpkgs

#svn export ${nixpkgs} ${archivesDir}/pkgs
tar -zcf  ${archivesDir}/nixpkgs.tgz ${nixpkgs}

#echo copying packages from store

echo copying scripts

$coreutils/bin/mkdir ${archivesDir}/scripts
$coreutils/bin/cp -fa * ${archivesDir}/scripts
$gnused/bin/sed -e "s^@bash\@^$bash^g" \
    -e "s^@coreutils\@^$coreutilsdiet^g" \
    -e "s^@busybox\@^$busybox^g" \
    < $initscript > $initscript.tmp
$coreutils/bin/mv $initscript.tmp $initscript
$gnused/bin/sed -e "s^@sysvinitPath\@^$sysvinitPath^g" \
    -e "s^@bootPath\@^$bootPath^g" \
    -e "s^@nix\@^$nix^g" \
    -e "s^@bash\@^$bash^g" \
    -e "s^@bashGlibc\@^$bashGlibc^g" \
    -e "s^@findutils\@^$findutils^g" \
    -e "s^@busybox\@^$busybox^g" \
    -e "s^@coreutilsdiet\@^$coreutilsdiet^g" \
    -e "s^@coreutils\@^$coreutils^g" \
    -e "s^@utilLinux\@^$utilLinux^g" \
    -e "s^@utillinux\@^$utillinux^g" \
    -e "s^@e2fsprogs\@^$e2fsprogs^g" \
    -e "s^@modutils\@^$modutils^g" \
    -e "s^@grub\@^$grub^g" \
    -e "s^@kernel\@^$kernel^g" \
    -e "s^@gnugrep\@^$gnugrep^g" \
    -e "s^@which\@^$which^g" \
    -e "s^@kudzu\@^$kudzu^g" \
    -e "s^@sysklogd\@^$sysklogd^g" \
    -e "s^@gnutar\@^$gnutar^g" \
    -e "s^@gzip\@^$gzip^g" \
    -e "s^@mingetty\@^$mingettyWrapper^g" \
    < $fill_disk > $fill_disk.tmp
$coreutils/bin/mv $fill_disk.tmp $fill_disk

$gnused/bin/sed -e "s^@sysvinitPath\@^$sysvinitPath^g" \
    -e "s^@bootPath\@^$bootPath^g" \
    -e "s^@NIX\@^$nix^g" \
    -e "s^@bash\@^$bash^g" \
    -e "s^@findutils\@^$findutils^g" \
    -e "s^@coreutilsdiet\@^$coreutilsdiet^g" \
    -e "s^@coreutils\@^$coreutils^g" \
    -e "s^@utillinux\@^$utilLinux^g" \
    -e "s^@e2fsprogs\@^$e2fsprogs^g" \
    -e "s^@modutils\@^$modutils^g" \
    -e "s^@grub\@^$grub^g" \
    -e "s^@kernel\@^$kernel^g" \
    -e "s^@gnugrep\@^$gnugrep^g" \
    -e "s^@which\@^$which^g" \
    -e "s^@gnutar\@^$gnutar^g" \
    -e "s^@mingetty\@^$mingettyWrapper^g" \
    < $ramdisk_login > $ramdisk_login.tmp
$coreutils/bin/mv $ramdisk_login.tmp $ramdisk_login

echo copying bootimage

$coreutils/bin/mkdir ${archivesDir}/isolinux
$coreutils/bin/cp ${syslinux}/lib/syslinux/isolinux.bin ${archivesDir}/isolinux
$coreutils/bin/cp isolinux.cfg ${archivesDir}/isolinux
$coreutils/bin/chmod u+w ${archivesDir}/isolinux/*

echo copying kernel

# By following the symlink we don't have to know the version number
# of the kernel here.
$coreutils/bin/cp -L $kernel/vmlinuz ${archivesDir}/isolinux

echo linking kernel modules

$coreutils/bin/ln -s $kernel/lib $archivesDir/lib

echo creating ramdisk

$coreutils/bin/rm -f ${initrd}
#cp ${archivesDir}/scripts/fill-disk.sh ${initdir}/init
$coreutils/bin/cp ${archivesDir}/scripts/fill-disk.sh ${initdir}/
$coreutils/bin/cp ${archivesDir}/scripts/ramdisk-login.sh ${initdir}/
$coreutils/bin/cp ${archivesDir}/scripts/init.sh ${initdir}/init
#ln -s ${bash}/bin/bash ${initdir}/bin/sh
$coreutils/bin/cp ${bash}/bin/bash ${initdir}/bin/sh
$coreutils/bin/chmod u+x ${initdir}/init
$coreutils/bin/chmod u+x ${initdir}/fill-disk.sh
$coreutils/bin/chmod u+x ${initdir}/ramdisk-login.sh
#cp -fau --parents ${utilLinux} ${initdir}
#cp -fau --parents ${coreUtilsDiet} ${initdir}
#cp -fau --parents ${modUtils} ${initdir}
$coreutils/bin/cp -fau --parents ${bash}/bin ${initdir}
#$coreutils/bin/cp -fau --parents ${utilLinux}/bin ${initdir}
#$coreutils/bin/chmod -R u+w ${initdir}
#$coreutils/bin/cp -fau --parents ${utilLinux}/sbin ${initdir}
$coreutils/bin/cp -fau --parents ${e2fsProgs} ${initdir}
#$coreutils/bin/cp -fau --parents ${coreutilsdiet}/bin ${initdir}
$coreutils/bin/cp -fau --parents ${modutils}/bin ${initdir}
$coreutils/bin/chmod -R u+w ${initdir}
$coreutils/bin/cp -fau --parents ${modutils}/sbin ${initdir}
$coreutils/bin/cp -fau --parents ${busybox} ${initdir}

$coreutils/bin/touch ${archivesDir}/NIXOS

(cd ${initdir}; find . |$cpio/bin/cpio -H newc -o) | $gzip/bin/gzip -9 > ${initrd}

$coreutils/bin/chmod -f -R +w ${initdir}/*
$coreutils/bin/rm -rf ${initdir}

$coreutils/bin/cp ${initrd} ${archivesDir}/isolinux
$coreutils/bin/rm -f ${initrd}

echo creating ISO image

$cdrtools/bin/mkisofs -rJ -o ${bootiso} -b isolinux/isolinux.bin \
                -c isolinux/boot.cat  -no-emul-boot -boot-load-size 4 \
                -boot-info-table ${archivesDir}

# cleanup, be diskspace friendly

echo cleaning up

$coreutils/bin/chmod -f -R +w ${archivesDir}/*
#rm -rf ${archivesDir}/*
