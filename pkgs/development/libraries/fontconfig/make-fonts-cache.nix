{ runCommand, lib, fontconfig, fontDirectories, buildPackages }:

runCommand "fc-cache"
  rec {
    nativeBuildInputs = [ buildPackages.fontconfig.bin ];
    preferLocalBuild = true;
    passAsFile = [ "fontDirs" ];
    fontDirs = ''
      <!-- Font directories -->
      ${lib.concatStringsSep "\n" (map (font: "<dir>${font}</dir>") fontDirectories)}
    '';
  }
  ''
    export FONTCONFIG_FILE=$(pwd)/fonts.conf

    cat > fonts.conf << EOF
    <?xml version='1.0'?>
    <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
    <fontconfig>
      <include>${fontconfig.out}/etc/fonts/fonts.conf</include>
      <cachedir>$out</cachedir>
    EOF
    cat "$fontDirsPath" >> fonts.conf
    echo "</fontconfig>" >> fonts.conf

    mkdir -p $out
    fc-cache -sv

    # This is not a cache dir in the normal sense -- it won't be automatically
    # recreated.
    rm -f "$out/CACHEDIR.TAG"
  ''
