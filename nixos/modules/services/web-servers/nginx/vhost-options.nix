# This file defines the options that can be used both for the Apache
# main server configuration, and for the virtual hosts.  (The latter
# has additional options that affect the web server as a whole, like
# the user/group to run under.)

{ lib }:

with lib;
{
  options = {
    serverAliases = mkOption {
      type = types.listOf types.str;
      default = [];
      example = ["www.example.org" "example.org"];
      description = ''
        Additional names of virtual hosts served by this virtual host configuration.
      '';
    };

    port = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = ''
        Port for the server. 80 for http
        and 443 for https (i.e. when enableSSL is set).
      '';
    };

    enableSSL = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable SSL (https) support.";
    };

    forceSSL = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to always redirect to https.";
    };

    sslCertificate = mkOption {
      type = types.path;
      example = "/var/host.cert";
      description = "Path to server SSL certificate.";
    };

    sslCertificateKey= mkOption {
      type = types.path;
      example = "/var/host.key";
      description = "Path to server SSL certificate key.";
    };

    root = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/data/webserver/docs";
      description = ''
        The path of the web root directory.
      '';
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        These lines go to the end of the vhost verbatim.
      '';
    };

    globalRedirect = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = http://newserver.example.org/;
      description = ''
        If set, all requests for this host are redirected permanently to
        the given URL.
      '';
    };

    basicAuth = mkOption {
      type = types.attrsOf types.str;
      default = {};
      description = "user = password";
    };

    locations = mkOption {
      type = types.attrsOf (types.submodule (import ./location-options.nix {
        inherit lib;
      }));
      default = {};
      example = {};
      description = ''
      '';
    };
  };
}
