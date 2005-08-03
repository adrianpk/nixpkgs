#! @bash@/bin/sh -e

export PATH=@bash@/bin:@coreutils@/bin:@findutils@/bin:@utillinux@/bin:@utillinux@/sbin

sysvinitPath=@sysvinitPath@
bootPath=@bootPath@

mount -t proc proc /proc
mount -t sysfs sys /sys

#mount -t /dev/hdc /installimage

# make a complete /dev filesystem
# ripped permissions and everything from anaconda (loader2/devices.h)

# consoles

mknod -m 0600 /dev/console c 5 1
mknod -m 0600 /dev/ttyS0 c 4 64
mknod -m 0600 /dev/ttyS1 c 4 65
mknod -m 0600 /dev/ttyS2 c 4 66
mknod -m 0600 /dev/ttyS3 c 4 67

# base UNIX devices
mknod -m 0600 /dev/mem c 1 1
mknod -m 0666 /dev/null c 1 3
mknod -m 0666 /dev/zero c 1 5

# tty
mknod -m 0600 /dev/tty c 5 0
mknod -m 0600 /dev/tty0 c 4 0
mknod -m 0600 /dev/tty1 c 4 1
mknod -m 0600 /dev/tty2 c 4 2
mknod -m 0600 /dev/tty3 c 4 3
mknod -m 0600 /dev/tty4 c 4 4
mknod -m 0600 /dev/tty5 c 4 5
mknod -m 0600 /dev/tty6 c 4 6
mknod -m 0600 /dev/tty7 c 4 7
mknod -m 0600 /dev/tty8 c 4 8
mknod -m 0600 /dev/tty9 c 4 9

mkdir -m 0755 /dev/pts
mknod -m 0666 /dev/ptmx c 5 2

# random

mknod -m 0644 /dev/random c 1 8
mknod -m 0644 /dev/urandom c 1 9

echo "blaat"

if ! test -n "$1"
then
    echo "need harddisk device for installing!"
    exit
else
    device=$1
fi

make_dir() {
    mode=$1
    name=$2
    echo creating $name...
    if ! test -d $root/$name; then mkdir $root/$name; fi
    chmod $mode $root/$name
}


touch_file() {
    name=$1
    echo touching $name...
    if ! test -d $root/$name; then touch $root/$name; fi
}
root=/tmp/mnt

mkdir -p /tmp/mnt

mount $device /tmp/mnt

# mkdir -p /nix
# mkdir -p /nixpkgs/trunk/pkgs

# temporary hack
# mount --bind /mnt/cdrom1/nix /nix
# mount --bind /mnt/cdrom1/pkgs /nixpkgs/trunk/pkgs

make_dir 00755 /bin
make_dir 00755 /dev
make_dir 00755 /proc
make_dir 01777 /tmp
make_dir 00755 /etc # global non-constant configuration
make_dir 00755 /etc-secret
make_dir 00755 /var
make_dir 00755 /nix
make_dir 00755 /nix/store
make_dir 00755 /nix/var
make_dir 00755 /nix/var/nix
make_dir 00755 /nix/var/nix/db
make_dir 00755 /nix/var/nix/manifests
make_dir 00755 /nix/var/log
make_dir 00755 /nix/var/log/nix
make_dir 00755 /nixpkgs
make_dir 00755 /nixpkgs/trunk
make_dir 00755 /mnt
make_dir 00755 /mnt/host
make_dir 00755 /home
make_dir 00755 /home/root

mknod $root/dev/null c 1 3

touch_file /etc/passwd
touch_file /etc/shadow
touch_file /etc/group

rm -f $root/etc/mtab
#ln -s /proc/mounts $root/etc/mtab

export NIX_DATA_DIR=$root/nix/share
export NIX_LOG_DIR=$root/nix/log/nix
export NIX_STATE_DIR=$root/nix/var/nix
export NIX_CONF_DIR=$root/nix/etc
NIX_CMD_PATH=@NIX_CMD_PATH@/bin

echo initialising Nix DB...
#/nix/bin/nix-store --init
$NIX_CMD_PATH/nix-store --init

echo verifying Nix DB...
$NIX_CMD_PATH/nix-store --verify

echo copying nixpkgs...
cp -fa ../pkgs $root/nixpkgs/trunk

make_dir 0755 /tmp/scripts
cp -fa ../scripts $root/tmp

#echo adding manifest
#$NIX_CMD_PATH/nix-pull $manifest

echo adding packages
export NIX_ROOT=$root
unset NIX_DATA_DIR
unset NIX_LOG_DIR
unset NIX_STATE_DIR
unset NIX_CONF_DIR

#storeExpr=$(echo '(import /tmp/scripts/pkgs.nix).everything' | $NIX_CMD_PATH/nix-instantiate -v -v -)
#storeExpr=$(echo '(import ./pkgs.nix).everything' | $NIX_CMD_PATH/nix-instantiate -v -v -)
#$NIX_CMD_PATH/nix-store -r $storeExpr
#echo $storeExpr
#storeExpr2=$($NIX_CMD_PATH/nix-store -qR $($NIX_CMD_PATH/nix-store -r $storeExpr))
#echo storeExpr $storeExpr
#echo $($NIX_CMD_PATH/nix-store -qR --include-outputs $storeExpr)

echo copying store

(while read storepaths; do
  cp -fa $storepaths $root/nix/store
done) < /mnt/cdrom1/mystorepaths

#cp -fa ../nix/store/* $root/nix/store

#echo registering valid paths...
#(while read storepath; do
#    echo PATH $storepath
#    if ! $NIX_CMD_PATH/nix-store --isvalid $storepath 2> /dev/null; then
#        (unset NIX_ROOT; $NIX_CMD_PATH/nix-store --dump $storepath) | $NIX_CMD_PATH/nix-store --restore $storepath
#        $NIX_CMD_PATH/nix-store --validpath $storepath
#    fi
#done) < /tmp/mystorepaths

#echo registering successors...
#(while read line; do
#    echo SUCC $line
#    $NIX_CMD_PATH/nix-store --successor $line
#done) < /tmp/mysuccessors

exit

echo setting init symlink...
rm -f $root/init
ln -s $sysvinitPath/sbin/init $root/init

echo setting up inittab...
rm -f $root/etc/inittab
echo "id:2:initdefault:" >> $root/etc/inittab
echo "si::bootwait:$bootPath/bin/boot.sh" >> $root/etc/inittab
echo "ht:06:wait:$bootPath/bin/halt.sh" >> $root/etc/inittab
echo "1:2345:respawn:$bootPath/bin/login.sh /dev/ttys/0" >> $root/etc/inittab
#echo "2:2345:respawn:$bootPath/bin/login.sh /dev/ttys/1" >> $root/etc/inittab

echo setting up networking information...
make_dir 00755 /etc/networking
echo 192.168.150.1 > $root/etc/networking/local-ip
echo 192.168.150.3 > $root/etc/networking/gateway-ip
cp /etc/resolv.conf $root/etc
rm -f $root/etc/hosts
echo "127.0.0.1 localhost" >> $root/etc/hosts
echo "192.168.150.1 uml" >> $root/etc/hosts
