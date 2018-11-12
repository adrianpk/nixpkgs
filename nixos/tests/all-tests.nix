{ system, pkgs, callTest }:
# The return value of this function will be an attrset with arbitrary depth and
# the `anything` returned by callTest at its test leafs.
# The tests not supported by `system` will be replaced with `{}`, so that
# `passthru.tests` can contain links to those without breaking on architectures
# where said tests are unsupported.
# Example callTest that just extracts the derivation from the test:
#   callTest = t: t.test;

with pkgs.lib;

let
  discoverTests = val:
    if !isAttrs val then val
    else if hasAttr "test" val then callTest val
    else mapAttrs (n: s: discoverTests s) val;
  handleTest = path: args:
    discoverTests (import path ({ inherit system pkgs; } // args));
  handleTestOn = systems: path: args:
    if elem system systems then handleTest path args
    else {};
in
{
  acme = handleTestOn ["x86_64-linux"] ./acme.nix {};
  atd = handleTest ./atd.nix {};
  avahi = handleTest ./avahi.nix {};
  bcachefs = handleTestOn ["x86_64-linux"] ./bcachefs.nix {}; # linux-4.18.2018.10.12 is unsupported on aarch64
  beegfs = handleTestOn ["x86_64-linux"] ./beegfs.nix {}; # beegfs is unsupported on aarch64
  bind = handleTest ./bind.nix {};
  bittorrent = handleTest ./bittorrent.nix {};
  #blivet = handleTest ./blivet.nix {};   # broken since 2017-07024
  boot = handleTestOn ["x86_64-linux"] ./boot.nix {}; # syslinux is unsupported on aarch64
  boot-stage1 = handleTest ./boot-stage1.nix {};
  borgbackup = handleTest ./borgbackup.nix {};
  buildbot = handleTest ./buildbot.nix {};
  cadvisor = handleTestOn ["x86_64-linux"] ./cadvisor.nix {};
  ceph = handleTestOn ["x86_64-linux"] ./ceph.nix {};
  certmgr = handleTest ./certmgr.nix {};
  cfssl = handleTestOn ["x86_64-linux"] ./cfssl.nix {};
  chromium = (handleTestOn ["x86_64-linux"] ./chromium.nix {}).stable or {};
  cjdns = handleTest ./cjdns.nix {};
  cloud-init = handleTest ./cloud-init.nix {};
  codimd = handleTest ./codimd.nix {};
  containers-bridge = handleTest ./containers-bridge.nix {};
  containers-extra_veth = handleTest ./containers-extra_veth.nix {};
  containers-hosts = handleTest ./containers-hosts.nix {};
  containers-imperative = handleTest ./containers-imperative.nix {};
  containers-ipv4 = handleTest ./containers-ipv4.nix {};
  containers-ipv6 = handleTest ./containers-ipv6.nix {};
  containers-macvlans = handleTest ./containers-macvlans.nix {};
  containers-physical_interfaces = handleTest ./containers-physical_interfaces.nix {};
  containers-restart_networking = handleTest ./containers-restart_networking.nix {};
  containers-tmpfs = handleTest ./containers-tmpfs.nix {};
  #couchdb = handleTest ./couchdb.nix {}; # spidermonkey-1.8.5 is marked as broken
  deluge = handleTest ./deluge.nix {};
  dhparams = handleTest ./dhparams.nix {};
  dnscrypt-proxy = handleTestOn ["x86_64-linux"] ./dnscrypt-proxy.nix {};
  docker = handleTestOn ["x86_64-linux"] ./docker.nix {};
  docker-edge = handleTestOn ["x86_64-linux"] ./docker-edge.nix {};
  docker-preloader = handleTestOn ["x86_64-linux"] ./docker-preloader.nix {};
  docker-registry = handleTest ./docker-registry.nix {};
  docker-tools = handleTestOn ["x86_64-linux"] ./docker-tools.nix {};
  docker-tools-overlay = handleTestOn ["x86_64-linux"] ./docker-tools-overlay.nix {};
  dovecot = handleTest ./dovecot.nix {};
  # ec2-config doesn't work in a sandbox as the simulated ec2 instance needs network access
  #ec2-config = (handleTestOn ["x86_64-linux"] ./ec2.nix {}).boot-ec2-config or {};
  ec2-nixops = (handleTestOn ["x86_64-linux"] ./ec2.nix {}).boot-ec2-nixops or {};
  ecryptfs = handleTest ./ecryptfs.nix {};
  elk = handleTestOn ["x86_64-linux"] ./elk.nix {};
  env = handleTest ./env.nix {};
  etcd = handleTestOn ["x86_64-linux"] ./etcd.nix {};
  ferm = handleTest ./ferm.nix {};
  firefox = handleTest ./firefox.nix {};
  firewall = handleTest ./firewall.nix {};
  flatpak = handleTest ./flatpak.nix {};
  fsck = handleTest ./fsck.nix {};
  fwupd = handleTestOn ["x86_64-linux"] ./fwupd.nix {}; # libsmbios is unsupported on aarch64
  gdk-pixbuf = handleTest ./gdk-pixbuf.nix {};
  gitea = handleTest ./gitea.nix {};
  gitlab = handleTest ./gitlab.nix {};
  gitolite = handleTest ./gitolite.nix {};
  gjs = handleTest ./gjs.nix {};
  gnome3 = handleTestOn ["x86_64-linux"] ./gnome3.nix {}; # libsmbios is unsupported on aarch64
  gnome3-gdm = handleTestOn ["x86_64-linux"] ./gnome3-gdm.nix {}; # libsmbios is unsupported on aarch64
  gocd-agent = handleTest ./gocd-agent.nix {};
  gocd-server = handleTest ./gocd-server.nix {};
  grafana = handleTest ./grafana.nix {};
  graphite = handleTest ./graphite.nix {};
  hadoop.hdfs = handleTestOn [ "x86_64-linux" ] ./hadoop/hdfs.nix {};
  hadoop.yarn = handleTestOn [ "x86_64-linux" ] ./hadoop/yarn.nix {};
  haproxy = handleTest ./haproxy.nix {};
  #hardened = handleTest ./hardened.nix {}; # broken due useSandbox = true
  hibernate = handleTest ./hibernate.nix {};
  hitch = handleTest ./hitch {};
  hocker-fetchdocker = handleTest ./hocker-fetchdocker {};
  home-assistant = handleTest ./home-assistant.nix {};
  hound = handleTest ./hound.nix {};
  hydra = handleTest ./hydra {};
  i3wm = handleTest ./i3wm.nix {};
  iftop = handleTest ./iftop.nix {};
  incron = handleTest tests/incron.nix {};
  influxdb = handleTest ./influxdb.nix {};
  initrd-network-ssh = handleTest ./initrd-network-ssh {};
  initrdNetwork = handleTest ./initrd-network.nix {};
  installer = handleTest ./installer.nix {};
  ipv6 = handleTest ./ipv6.nix {};
  jenkins = handleTest ./jenkins.nix {};
  kafka = handleTest ./kafka.nix {};
  kernel-latest = handleTest ./kernel-latest.nix {};
  kernel-lts = handleTest ./kernel-lts.nix {};
  keymap = handleTest ./keymap.nix {};
  kubernetes.dns = handleTestOn ["x86_64-linux"] ./kubernetes/dns.nix {};
  # kubernetes.e2e should eventually replace kubernetes.rbac when it works
  #kubernetes.e2e = handleTestOn ["x86_64-linux"] ./kubernetes/e2e.nix {};
  kubernetes.rbac = handleTestOn ["x86_64-linux"] ./kubernetes/rbac.nix {};
  latestKernel.login = handleTest ./login.nix { latestKernel = true; };
  ldap = handleTest ./ldap.nix {};
  leaps = handleTest ./leaps.nix {};
  #lightdm = handleTest ./lightdm.nix {};
  login = handleTest ./login.nix {};
  #logstash = handleTest ./logstash.nix {};
  mathics = handleTest ./mathics.nix {};
  matrix-synapse = handleTest ./matrix-synapse.nix {};
  memcached = handleTest ./memcached.nix {};
  mesos = handleTest ./mesos.nix {};
  misc = handleTest ./misc.nix {};
  mongodb = handleTest ./mongodb.nix {};
  morty = handleTest ./morty.nix {};
  mpd = handleTest ./mpd.nix {};
  mumble = handleTest ./mumble.nix {};
  munin = handleTest ./munin.nix {};
  mutableUsers = handleTest ./mutable-users.nix {};
  mysql = handleTest ./mysql.nix {};
  mysqlBackup = handleTest ./mysql-backup.nix {};
  mysqlReplication = handleTest ./mysql-replication.nix {};
  nat.firewall = handleTest ./nat.nix { withFirewall = true; };
  nat.firewall-conntrack = handleTest ./nat.nix { withFirewall = true; withConntrackHelpers = true; };
  nat.standalone = handleTest ./nat.nix { withFirewall = false; };
  netdata = handleTest ./netdata.nix {};
  networking.networkd = handleTest ./networking.nix { networkd = true; };
  networking.scripted = handleTest ./networking.nix { networkd = false; };
  # TODO: put in networking.nix after the test becomes more complete
  networkingProxy = handleTest ./networking-proxy.nix {};
  nextcloud = handleTest ./nextcloud {};
  nexus = handleTest ./nexus.nix {};
  nfs3 = handleTest ./nfs.nix { version = 3; };
  nfs4 = handleTest ./nfs.nix { version = 4; };
  nghttpx = handleTest ./nghttpx.nix {};
  nginx = handleTest ./nginx.nix {};
  nix-ssh-serve = handleTest ./nix-ssh-serve.nix {};
  novacomd = handleTestOn ["x86_64-linux"] ./novacomd.nix {};
  nsd = handleTest ./nsd.nix {};
  openldap = handleTest ./openldap.nix {};
  opensmtpd = handleTest ./opensmtpd.nix {};
  openssh = handleTest ./openssh.nix {};
  osquery = handleTest ./osquery.nix {};
  ostree = handleTest ./ostree.nix {};
  owncloud = handleTest ./owncloud.nix {};
  pam-oath-login = handleTest ./pam-oath-login.nix {};
  peerflix = handleTest ./peerflix.nix {};
  pgjwt = handleTest ./pgjwt.nix {};
  pgmanage = handleTest ./pgmanage.nix {};
  php-pcre = handleTest ./php-pcre.nix {};
  plasma5 = handleTest ./plasma5.nix {};
  plotinus = handleTest ./plotinus.nix {};
  postgis = handleTest ./postgis.nix {};
  postgresql = handleTest ./postgresql.nix {};
  powerdns = handleTest ./powerdns.nix {};
  predictable-interface-names = handleTest ./predictable-interface-names.nix {};
  printing = handleTest ./printing.nix {};
  prometheus = handleTest ./prometheus.nix {};
  prometheus-exporters = handleTest ./prometheus-exporters.nix {};
  prosody = handleTest ./prosody.nix {};
  proxy = handleTest ./proxy.nix {};
  quagga = handleTest ./quagga.nix {};
  quake3 = handleTest ./quake3.nix {};
  rabbitmq = handleTest ./rabbitmq.nix {};
  radicale = handleTest ./radicale.nix {};
  redmine = handleTest ./redmine.nix {};
  rspamd = handleTest ./rspamd.nix {};
  rsyslogd = handleTest ./rsyslogd.nix {};
  runInMachine = handleTest ./run-in-machine.nix {};
  rxe = handleTest ./rxe.nix {};
  samba = handleTest ./samba.nix {};
  sddm = handleTest ./sddm.nix {};
  simple = handleTest ./simple.nix {};
  slim = handleTest ./slim.nix {};
  slurm = handleTest ./slurm.nix {};
  smokeping = handleTest ./smokeping.nix {};
  snapper = handleTest ./snapper.nix {};
  solr = handleTest ./solr.nix {};
  #statsd = handleTest ./statsd.nix {}; # statsd is broken: #45946
  strongswan-swanctl = handleTest ./strongswan-swanctl.nix {};
  sudo = handleTest ./sudo.nix {};
  switchTest = handleTest ./switch-test.nix {};
  systemd = handleTest ./systemd.nix {};
  taskserver = handleTest ./taskserver.nix {};
  tomcat = handleTest ./tomcat.nix {};
  tor = handleTest ./tor.nix {};
  transmission = handleTest ./transmission.nix {};
  udisks2 = handleTest ./udisks2.nix {};
  upnp = handleTest ./upnp.nix {};
  vault = handleTest ./vault.nix {};
  virtualbox = handleTestOn ["x86_64-linux"] ./virtualbox.nix {};
  wordpress = handleTest ./wordpress.nix {};
  xautolock = handleTest ./xautolock.nix {};
  xdg-desktop-portal = handleTest ./xdg-desktop-portal.nix {};
  xfce = handleTest ./xfce.nix {};
  xmonad = handleTest ./xmonad.nix {};
  xrdp = handleTest ./xrdp.nix {};
  xss-lock = handleTest ./xss-lock.nix {};
  yabar = handleTest ./yabar.nix {};
  zookeeper = handleTest ./zookeeper.nix {};
}
