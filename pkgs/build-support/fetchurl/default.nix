{ lib, stdenvNoCC, curl }: # Note that `curl' may be `null', in case of the native stdenvNoCC.

let

  mirrors = import ./mirrors.nix;

  # Write the list of mirrors to a file that we can reuse between
  # fetchurl instantiations, instead of passing the mirrors to
  # fetchurl instantiations via environment variables.  This makes the
  # resulting store derivations (.drv files) much smaller, which in
  # turn makes nix-env/nix-instantiate faster.
  mirrorsFile =
    stdenvNoCC.mkDerivation ({
      name = "mirrors-list";
      builder = ./write-mirror-list.sh;
      preferLocalBuild = true;
    } // mirrors);

  # Names of the master sites that are mirrored (i.e., "sourceforge",
  # "gnu", etc.).
  sites = builtins.attrNames mirrors;

  impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
    # This variable allows the user to pass additional options to curl
    "NIX_CURL_FLAGS"

    # This variable allows the user to override hashedMirrors from the
    # command-line.
    "NIX_HASHED_MIRRORS"

    # This variable allows overriding the timeout for connecting to
    # the hashed mirrors.
    "NIX_CONNECT_TIMEOUT"
  ] ++ (map (site: "NIX_MIRRORS_${site}") sites);

in

{ # URL to fetch.
  url ? ""

, # Alternatively, a list of URLs specifying alternative download
  # locations.  They are tried in order.
  urls ? []

, # Additional curl options needed for the download to succeed.
  curlOpts ? ""

, # Name of the file.  If empty, use the basename of `url' (or of the
  # first element of `urls').
  name ? ""

  # Different ways of specifying the hash.
, outputHash ? ""
, outputHashAlgo ? ""
, md5 ? ""
, sha1 ? ""
, sha256 ? ""
, sha512 ? ""

, recursiveHash ? false

, # Shell code to build a netrc file for BASIC auth
  netrcPhase ? null

, # Impure env vars (http://nixos.org/nix/manual/#sec-advanced-attributes)
  # needed for netrcPhase
  netrcImpureEnvVars ? []

, # Shell code executed after the file has been fetched
  # successfully. This can do things like check or transform the file.
  postFetch ? ""

, # Whether to download to a temporary path rather than $out. Useful
  # in conjunction with postFetch. The location of the temporary file
  # is communicated to postFetch via $downloadedFile.
  downloadToTemp ? false

, # If true, set executable bit on downloaded file
  executable ? false

, # If set, don't download the file, but write a list of all possible
  # URLs (resulting from resolving mirror:// URLs) to $out.
  showURLs ? false

, # Meta information, if any.
  meta ? {}

  # Passthru information, if any.
, passthru ? {}
}:

assert sha512 != "" -> builtins.compareVersions "1.11" builtins.nixVersion <= 0;

let
  urls_ =
    if urls != [] && url == "" then
      (if lib.isList urls then urls
       else throw "`urls` is not a list")
    else if urls == [] && url != "" then [url]
    else throw "fetchurl requires either `url` or `urls` to be set";

  hash_ =
    if md5 != "" then throw "fetchurl does not support md5 anymore, please use sha256 or sha512"
    else if (outputHash != "" && outputHashAlgo != "") then { inherit outputHashAlgo outputHash; }
    else if sha512 != "" then { outputHashAlgo = "sha512"; outputHash = sha512; }
    else if sha256 != "" then { outputHashAlgo = "sha256"; outputHash = sha256; }
    else if sha1   != "" then { outputHashAlgo = "sha1";   outputHash = sha1; }
    else throw "fetchurl requires a hash for fixed-output derivation: ${lib.concatStringsSep ", " urls_}";
in

stdenvNoCC.mkDerivation {
  name =
    if showURLs then "urls"
    else if name != "" then name
    else baseNameOf (toString (builtins.head urls_));

  builder = ./builder.sh;

  nativeBuildInputs = [ curl ];

  urls = urls_;

  # If set, prefer the content-addressable mirrors
  # (http://tarballs.nixos.org) over the original URLs.
  preferHashedMirrors = true;

  # New-style output content requirements.
  inherit (hash_) outputHashAlgo outputHash;

  outputHashMode = if (recursiveHash || executable) then "recursive" else "flat";

  inherit curlOpts showURLs mirrorsFile postFetch downloadToTemp executable;

  impureEnvVars = impureEnvVars ++ netrcImpureEnvVars;

  nixpkgsVersion = lib.release;

  # Doing the download on a remote machine just duplicates network
  # traffic, so don't do that.
  preferLocalBuild = true;

  postHook = if netrcPhase == null then null else ''
    ${netrcPhase}
    curlOpts="$curlOpts --netrc-file $PWD/netrc"
  '';

  inherit meta;
  inherit passthru;
}
