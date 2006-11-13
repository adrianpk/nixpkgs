{ genericSubstituter, shell, coreutils, findutils
, utillinux, kernel, sysklogd, mingetty, udev
, module_init_tools, nettools, dhcp
, path ? []

, # Whether the root device is root only.  If so, we'll mount a
  # ramdisk on /etc, /var and so on.
  readOnlyRoot
}:

genericSubstituter {
  src = ./boot-stage-2-init.sh;
  isExecutable = true;
  inherit shell kernel sysklogd mingetty readOnlyRoot;
  path = [
    coreutils
    findutils
    utillinux
    udev
    module_init_tools
    nettools
    dhcp
  ];
  extraPath = path;
}
