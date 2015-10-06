{ stdenv, stdenv_32bit, fetchurl, unzip, makeWrapper
, platformTools, buildTools, support, supportRepository, platforms, sysimages, addons
, zlib_32bit
, libX11_32bit, libxcb_32bit, libXau_32bit, libXdmcp_32bit, libXext_32bit, mesa_32bit, alsaLib_32bit
, libX11, libXext, libXrender, libxcb, libXau, libXdmcp, libXtst, mesa, alsaLib
, freetype, fontconfig, glib, gtk, atk, file, jdk, coreutils
}:
{ platformVersions, abiVersions, useGoogleAPIs, useExtraSupportLibs ? false, useGooglePlayServices ? false }:

stdenv.mkDerivation rec {
  name = "android-sdk-${version}";
  version = "24.3.4";

  src = if (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux")
    then fetchurl {
      url = "http://dl.google.com/android/android-sdk_r${version}-linux.tgz";
      sha1 = "fb293d7bca42e05580be56b1adc22055d46603dd";
    }
    else if stdenv.system == "x86_64-darwin" then fetchurl {
      url = "http://dl.google.com/android/android-sdk_r${version}-macosx.zip";
      sha1 = "128f10fba668ea490cc94a08e505a48a608879b9";
    }
    else throw "platform not ${stdenv.system} supported!";

  buildCommand = ''
    mkdir -p $out/libexec
    cd $out/libexec
    unpackFile $src
    cd android-sdk-*/tools

    for f in android traceview draw9patch hierarchyviewer monitor ddms screenshot2 uiautomatorviewer monkeyrunner jobb lint
    do
        sed -i -e "s|/bin/ls|${coreutils}/bin/ls|" "$f"
    done

    ${stdenv.lib.optionalString (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux")
    ''
      # There are a number of native binaries. We must patch them to let them find the interpreter and libstdc++
      
      for i in emulator emulator-arm emulator-mips emulator-x86 mksdcard
      do
          patchelf --set-interpreter ${stdenv_32bit.cc.libc}/lib/ld-linux.so.2 $i
          patchelf --set-rpath ${stdenv_32bit.cc.cc}/lib $i
      done
      
      ${stdenv.lib.optionalString (stdenv.system == "x86_64-linux") ''
        # We must also patch the 64-bit emulator instances, if needed
        
        for i in emulator64-arm emulator64-mips emulator64-x86
        do
            patchelf --set-interpreter ${stdenv.cc.libc}/lib/ld-linux-x86-64.so.2 $i
            patchelf --set-rpath ${stdenv.cc.cc}/lib64 $i
        done
      ''}
      
      # The android script used SWT and wants to dynamically load some GTK+ stuff.
      # The following wrapper ensures that they can be found:
      wrapProgram `pwd`/android \
        --prefix PATH : ${jdk}/bin \
        --prefix LD_LIBRARY_PATH : ${glib}/lib:${gtk}/lib:${libXtst}/lib
    
      # The emulators need additional libraries, which are dynamically loaded => let's wrap them
    
      for i in emulator emulator-arm emulator-mips emulator-x86
      do
          wrapProgram `pwd`/$i \
            --prefix PATH : ${file}/bin \
            --suffix LD_LIBRARY_PATH : `pwd`/lib:${libX11_32bit}/lib:${libxcb_32bit}/lib:${libXau_32bit}/lib:${libXdmcp_32bit}/lib:${libXext_32bit}/lib:${mesa_32bit}/lib
      done
      
      ${stdenv.lib.optionalString (stdenv.system == "x86_64-linux") ''
        for i in emulator64-arm emulator64-mips emulator64-x86
        do
            wrapProgram `pwd`/$i \
              --prefix PATH : ${file}/bin \
              --suffix LD_LIBRARY_PATH : `pwd`/lib:${libX11}/lib:${libxcb}/lib:${libXau}/lib:${libXdmcp}/lib:${libXext}/lib:${mesa}/lib:${alsaLib}/lib
        done
      ''}
    ''}

    patchShebangs .
    
    ${if stdenv.system == "i686-linux" then
      ''
        # The monitor requires some more patching
        
        cd lib/monitor-x86
        patchelf --set-interpreter ${stdenv.cc.libc}/lib/ld-linux.so.2 monitor
        patchelf --set-rpath ${libX11}/lib:${libXext}/lib:${libXrender}/lib:${freetype}/lib:${fontconfig}/lib libcairo-swt.so
        
        wrapProgram `pwd`/monitor \
          --prefix LD_LIBRARY_PATH : ${gtk}/lib:${atk}/lib:${stdenv.cc.cc}/lib:${libXtst}/lib

        cd ../..
      ''
      else if stdenv.system == "x86_64-linux" then
      ''
        # The monitor requires some more patching
        
        cd lib/monitor-x86_64
        patchelf --set-interpreter ${stdenv.cc.libc}/lib/ld-linux-x86-64.so.2 monitor
        patchelf --set-rpath ${libX11}/lib:${libXext}/lib:${libXrender}/lib:${freetype}/lib:${fontconfig}/lib libcairo-swt.so
        
        wrapProgram `pwd`/monitor \
          --prefix LD_LIBRARY_PATH : ${gtk}/lib:${atk}/lib:${stdenv.cc.cc}/lib::${libXtst}/lib

        cd ../..
      ''
      else ""}
    
    # Symlink the other sub packages
    
    cd ..
    ln -s ${platformTools}/platform-tools
    ln -s ${buildTools}/build-tools
    ln -s ${support}/support
    
    # Symlink required Google API add-ons
    
    mkdir -p add-ons
    cd add-ons
    
    ${if useGoogleAPIs then
        stdenv.lib.concatMapStrings (platformVersion:
        if (builtins.hasAttr ("google_apis_"+platformVersion) addons) then
          let
            googleApis = builtins.getAttr ("google_apis_"+platformVersion) addons;
          in
          "ln -s ${googleApis}/* addon-google_apis-${platformVersion}\n"
        else "") platformVersions
      else ""}
      
    cd ..

    # Symlink required extras

    mkdir -p extras/android
    cd extras/android

    ln -s ${supportRepository}/m2repository

    ${if useExtraSupportLibs then
       "ln -s ${addons.android_support_extra}/support ."
     else ""}

    cd ..
    mkdir -p google
    cd google

    ${if useGooglePlayServices then
       "ln -s ${addons.google_play_services}/google-play-services google_play_services"
     else ""}
      
    cd ../..

    # Symlink required platforms
   
    mkdir -p platforms
    cd platforms
    
    ${stdenv.lib.concatMapStrings (platformVersion:
      if (builtins.hasAttr ("platform_"+platformVersion) platforms) then
        let
          platform = builtins.getAttr ("platform_"+platformVersion) platforms;
        in
        "ln -s ${platform}/* android-${platformVersion}\n"
      else ""
    ) platformVersions}
    
    cd ..
    
    # Symlink required system images
  
    mkdir -p system-images
    cd system-images
    
    ${stdenv.lib.concatMapStrings (abiVersion:
      stdenv.lib.concatMapStrings (platformVersion:
        if (builtins.hasAttr ("sysimg_" + abiVersion + "_" + platformVersion) sysimages) then
          let
            sysimg = builtins.getAttr ("sysimg_" + abiVersion + "_" + platformVersion) sysimages;
          in
          ''
            mkdir -p android-${platformVersion}
            cd android-${platformVersion}
            ln -s ${sysimg}/*
            cd ..
          ''
        else ""
      ) platformVersions
    ) abiVersions}
    
    # Create wrappers to the most important tools and platform tools so that we can run them if the SDK is in our PATH
    
    mkdir -p $out/bin

    for i in $out/libexec/android-sdk-*/tools/*
    do
        if [ ! -d $i ] && [ -x $i ]
        then
            ln -sf $i $out/bin/$(basename $i)
        fi
    done
    
    for i in $out/libexec/android-sdk-*/platform-tools/*
    do
        if [ ! -d $i ] && [ -x $i ]
        then
            ln -sf $i $out/bin/$(basename $i)
        fi
    done

    for i in $out/libexec/android-sdk-*/build-tools/android-*/*
    do
        if [ ! -d $i ] && [ -x $i ]
        then
            ln -sf $i $out/bin/$(basename $i)
        fi
    done
  '';
  
  buildInputs = [ unzip makeWrapper ];
}
