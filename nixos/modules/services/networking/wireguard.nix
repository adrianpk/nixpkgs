{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.networking.wireguard;

  kernel = config.boot.kernelPackages;

  # interface options

  interfaceOpts = { name, ... }: {

    options = {

      ips = mkOption {
        example = [ "192.168.2.1/24" ];
        default = [];
        type = with types; listOf str;
        description = "The IP addresses of the interface.";
      };

      privateKey = mkOption {
        example = "yAnz5TF+lXXJte14tji3zlMNq+hd2rYUIgJBgB3fBmk=";
        type = types.str;
        description = "Base64 private key generated by wg genkey.";
      };

      presharedKey = mkOption {
        default = null;
        example = "rVXs/Ni9tu3oDBLS4hOyAUAa1qTWVA3loR8eL20os3I=";
        type = with types; nullOr str;
        description = ''base64 preshared key generated by wg genpsk. Optional,
        and may be omitted. This option adds an additional layer of
        symmetric-key cryptography to be mixed into the already existing
        public-key  cryptography, for post-quantum resistance.'';
      };

      listenPort = mkOption {
        default = null;
        type = with types; nullOr int;
        example = 51820;
        description = ''16-bit port for listening. Optional; if not specified,
        automatically generated based on interface name.'';
      };

      preSetup = mkOption {
        example = literalExample [''
          ${pkgs.iproute}/bin/ip netns add foo
        ''];
        default = [];
        type = with types; listOf str;
        description = ''A list of commands called at the start of the interface
        setup.'';
      };

      postSetup = mkOption {
        example = literalExample [''
          ${pkgs.bash} -c 'printf "nameserver 10.200.100.1" | ${pkgs.openresolv}/bin/resolvconf -a wg0 -m 0'
        ''];
        default = [];
        type = with types; listOf str;
        description = "A list of commands called at the end of the interface setup.";
      };

      postShutdown = mkOption {
        example = literalExample ["${pkgs.openresolv}/bin/resolvconf -d wg0"];
        default = [];
        type = with types; listOf str;
        description = "A list of commands called after shutting down the interface.";
      };

      peers = mkOption {
        default = [];
        description = "Peers linked to the interface.";
        type = with types; listOf (submodule peerOpts);
      };

    };

  };

  # peer options

  peerOpts = {

    options = {

      publicKey = mkOption {
        example = "xTIBA5rboUvnH4htodjb6e697QjLERt1NAB4mZqp8Dg=";
        type = types.str;
        description = "The base64 public key the peer.";
      };

      allowedIPs = mkOption {
        example = [ "10.192.122.3/32" "10.192.124.1/24" ];
        type = with types; listOf str;
        description = ''List of IP (v4 or v6) addresses with CIDR masks from
        which this peer is allowed to send incoming traffic and to which
        outgoing traffic for this peer is directed. The catch-all 0.0.0.0/0 may
        be specified for matching all IPv4 addresses, and ::/0 may be specified
        for matching all IPv6 addresses.'';
      };

      endpoint = mkOption {
        default = null;
        example = "demo.wireguard.io:12913";
        type = with types; nullOr str;
        description = ''Endpoint IP or hostname of the peer, followed by a colon,
        and then a port number of the peer.'';
      };

      persistentKeepalive = mkOption {
        default = null;
        type = with types; nullOr int;
        example = 25;
        description = ''This is optional and is by default off, because most
        users will not need it. It represents, in seconds, between 1 and 65535
        inclusive, how often to send an authenticated empty packet to the peer,
        for the purpose of keeping a stateful firewall or NAT mapping valid
        persistently. For example, if the interface very rarely sends traffic,
        but it might at anytime receive traffic from a peer, and it is behind
        NAT, the interface might benefit from having a persistent keepalive
        interval of 25 seconds; however, most users will not need this.'';
      };

    };

  };

  generateConf = name: values: pkgs.writeText "wireguard-${name}.conf" ''
    [Interface]
    PrivateKey = ${values.privateKey}
    ${optionalString (values.presharedKey != null) "PresharedKey = ${values.presharedKey}"}
    ${optionalString (values.listenPort != null)   "ListenPort = ${toString values.listenPort}"}

    ${concatStringsSep "\n\n" (map (peer: ''
    [Peer]
    PublicKey = ${peer.publicKey}
    ${optionalString (peer.allowedIPs != []) "AllowedIPs = ${concatStringsSep ", " peer.allowedIPs}"}
    ${optionalString (peer.endpoint != null) "Endpoint = ${peer.endpoint}"}
    ${optionalString (peer.persistentKeepalive != null) "PersistentKeepalive = ${toString peer.persistentKeepalive}"}
    '') values.peers)}
  '';

  ipCommand = "${pkgs.iproute}/bin/ip";
  wgCommand = "${pkgs.wireguard}/bin/wg";

  generateUnit = name: values:
    nameValuePair "wireguard-${name}"
      {
        description = "WireGuard Tunnel - ${name}";
        wantedBy = [ "ip-up.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = lib.flatten([
            values.preSetup

            "-${ipCommand} link del dev ${name}"
            "${ipCommand} link add dev ${name} type wireguard"
            "${wgCommand} setconf ${name} ${generateConf name values}"

            (map (ip:
            ''${ipCommand} address add ${ip} dev ${name}''
            ) values.ips)

            "${ipCommand} link set up dev ${name}"

            (flatten (map (peer: (map (ip:
            "${ipCommand} route add ${ip} dev ${name}"
            ) peer.allowedIPs)) values.peers))

            values.postSetup
          ]);

          ExecStop = [ ''${ipCommand} link del dev "${name}"'' ] ++ values.postShutdown;
        };
      };

in

{

  ###### interface

  options = {

    networking.wireguard = {

      interfaces = mkOption {
        description = "Wireguard interfaces.";
        default = {};
        example = {
          wg0 = {
            ips = [ "192.168.20.4/24" ];
            privateKey = "yAnz5TF+lXXJte14tji3zlMNq+hd2rYUIgJBgB3fBmk=";
            peers = [
              { allowedIPs = [ "192.168.20.1/32" ];
                publicKey  = "xTIBA5rboUvnH4htodjb6e697QjLERt1NAB4mZqp8Dg=";
                endpoint   = "demo.wireguard.io:12913"; }
            ];
          };
        };
        type = with types; attrsOf (submodule interfaceOpts);
      };

    };

  };


  ###### implementation

  config = mkIf (cfg.interfaces != {}) {

    boot.extraModulePackages = [ kernel.wireguard ];
    environment.systemPackages = [ pkgs.wireguard ];

    systemd.services = mapAttrs' generateUnit cfg.interfaces;

  };

}
