{ stdenv, pkgs, fetchurl, makeWrapper, wrapGAppsHook, gvfs, gtk3, atomEnv }:

let
  versions = {
    atom = {
      version = "1.34.0";
      sha256 = "16hrjymrc43izg7frcrk7cwjwwrclcxzcwb5iw2llzjc6iadzlkb";
    };

    atom-beta = {
      version = "1.35.0";
      beta = 0;
      sha256 = "0gm5k573dq1hhnyw3719f5k1c6rsz872mhzg8q53n89y0g2r5xmw";
    };
  };

  common = pname: {version, sha256, beta ? null}:
      let fullVersion = version + stdenv.lib.optionalString (beta != null) "-beta${toString beta}";
      name = "${pname}-${fullVersion}";
  in stdenv.mkDerivation {
    inherit name;
    version = fullVersion;

    src = fetchurl {
      url = "https://github.com/atom/atom/releases/download/v${fullVersion}/atom-amd64.deb";
      name = "${name}.deb";
      inherit sha256;
    };

    nativeBuildInputs = [
      wrapGAppsHook  # Fix error: GLib-GIO-ERROR **: No GSettings schemas are installed on the system
    ];

    buildInputs = [
      gtk3  # Fix error: GLib-GIO-ERROR **: Settings schema 'org.gtk.Settings.FileChooser' is not installed
    ];

    preFixup = ''
      gappsWrapperArgs+=(
        --prefix "PATH" : "${gvfs}/bin" \
      )
    '';

    buildCommand = ''
      mkdir -p $out/usr/
      ar p $src data.tar.xz | tar -C $out -xJ ./usr
      sed -i -e "s|Exec=.*$|Exec=$out/bin/${pname}|" $out/usr/share/applications/${pname}.desktop
      mv $out/usr/* $out/
      rm -r $out/share/lintian
      rm -r $out/usr/
      sed -i "s/${pname})/.${pname}-wrapped)/" $out/bin/${pname}

      fixupPhase

      share=$out/share/${pname}

      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${atomEnv.libPath}:$share" \
        $share/atom
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${atomEnv.libPath}" \
        $share/resources/app/apm/bin/node
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        $share/resources/app.asar.unpacked/node_modules/symbols-view/vendor/ctags-linux

      dugite=$share/resources/app.asar.unpacked/node_modules/dugite
      rm -f $dugite/git/bin/git
      ln -s ${pkgs.git}/bin/git $dugite/git/bin/git
      rm -f $dugite/git/libexec/git-core/git
      ln -s ${pkgs.git}/bin/git $dugite/git/libexec/git-core/git

      find $share -name "*.node" -exec patchelf --set-rpath "${atomEnv.libPath}:$share" {} \;
    '';

    meta = with stdenv.lib; {
      description = "A hackable text editor for the 21st Century";
      homepage = https://atom.io/;
      license = licenses.mit;
      maintainers = with maintainers; [ offline nequissimus ysndr ];
      platforms = platforms.x86_64;
    };
  };
in stdenv.lib.mapAttrs common versions
