{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

with stdenv.lib;

buildLinux (args // rec {
  version = "4.16.10";

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  modDirVersion = concatStrings (intersperse "." (take 3 (splitString "." "${version}.0")));

  # branchVersion needs to be x.y
  extraMeta.branch = concatStrings (intersperse "." (take 2 (splitString "." version)));

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1gnf16p4rmibcn3wn5zp4pl2zmhgk4dg6718gvdr8vcffd87ksc0";
  };
} // (args.argsOverride or {}))
