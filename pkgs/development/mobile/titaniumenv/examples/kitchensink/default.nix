{ titaniumenv, fetchgit, target, androidPlatformVersions ? [ "23" ], tiVersion ? "5.1.2.GA", release ? false
, rename ? false, stdenv ? null, newBundleId ? null, iosMobileProvisioningProfile ? null, iosCertificate ? null, iosCertificateName ? null, iosCertificatePassword ? null, iosVersion ? "8.1"
, enableWirelessDistribution ? false, installURL ? null
}:

assert rename -> (stdenv != null && newBundleId != null && iosMobileProvisioningProfile != null && iosCertificate != null && iosCertificateName != null && iosCertificatePassword != null);

let
  src = fetchgit {
    url = https://github.com/appcelerator/KitchenSink.git;
    rev = "6e9f509069fafdebfa78e15b2d14f20a27a485cc";
    sha256 = "0370dc0ca78b96a7e0befbff9cb1c248695e1aff66aceea98043bbb16c5121e6";
  };
  
  # Rename the bundle id to something else
  renamedSrc = stdenv.mkDerivation {
    name = "KitchenSink-renamedsrc";
    inherit src;
    buildPhase = ''
      sed -i -e "s|com.appcelerator.kitchensink|${newBundleId}|" tiapp.xml
      sed -i -e "s|com.appcelerator.kitchensink|${newBundleId}|" manifest
    '';
    installPhase = ''
      mkdir -p $out
      mv * $out
    '';
  };
in
titaniumenv.buildApp {
  name = "KitchenSink-${target}-${if release then "release" else "debug"}";
  src = if rename then renamedSrc else src;
  inherit tiVersion;
  
  inherit target androidPlatformVersions release;
  
  androidKeyStore = ./keystore;
  androidKeyAlias = "myfirstapp";
  androidKeyStorePassword = "mykeystore";
  
  inherit iosMobileProvisioningProfile iosCertificate iosCertificateName iosCertificatePassword iosVersion;
  inherit enableWirelessDistribution installURL;
}
