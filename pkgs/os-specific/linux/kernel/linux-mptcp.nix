{ stdenv, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  mptcpVersion = "0.91";
  modDirVersion = "4.1.26";
  version = "${modDirVersion}-mptcp_v${mptcpVersion}";

  extraMeta = {
    branch = "4.1";
    maintainers = [ stdenv.lib.maintainers.layus ];
  };

  src = fetchurl {
    url = "https://github.com/multipath-tcp/mptcp/archive/v${mptcpVersion}.tar.gz";
    sha256 = "0rbvgz89j5wk781y201qdxy2kz4gmlamb72wdbxj8mxv92x56lh3";
  };

  kernelPatches = args.kernelPatches;

  extraConfig = ''
    IPV6 y
    MPTCP y
    IP_MULTIPLE_TABLES y

    # Enable advanced path-managers...
    MPTCP_PM_ADVANCED y
    MPTCP_FULLMESH y
    MPTCP_NDIFFPORTS y
    # ... but use none by default.
    # The default is safer if source policy routing is not setup.
    DEFAULT_DUMMY y
    DEFAULT_MPTCP_PM "default"

    # MPTCP scheduler selection.
    # Disabled as the only non-default is the useless round-robin.
    MPTCP_SCHED_ADVANCED n
    DEFAULT_MPTCP_SCHED "default"

    # Smarter TCP congestion controllers
    TCP_CONG_LIA m
    TCP_CONG_OLIA m
    TCP_CONG_WVEGAS m
    TCP_CONG_BALIA m
  '';

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
