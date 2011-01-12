{ nixpkgs, services, system }:

with import ./build-vms.nix { inherit nixpkgs services system; };
with pkgs;

rec {

  inherit pkgs;


  testDriver = stdenv.mkDerivation {
    name = "nixos-test-driver";

    buildInputs = [ makeWrapper perl ];

    unpackPhase = "true";
    
    installPhase =
      ''
        mkdir -p $out/bin
        cp ${./test-driver/test-driver.pl} $out/bin/nixos-test-driver
        chmod u+x $out/bin/nixos-test-driver
        
        libDir=$out/lib/perl5/site_perl
        mkdir -p $libDir
        cp ${./test-driver/Machine.pm} $libDir/Machine.pm
        cp ${./test-driver/Logger.pm} $libDir/Logger.pm

        wrapProgram $out/bin/nixos-test-driver \
          --prefix PATH : "${pkgs.qemu_kvm}/bin:${pkgs.vde2}/bin:${imagemagick}/bin" \
          --prefix PERL5LIB : "${lib.makePerlPath [ perlPackages.TermReadLineGnu perlPackages.XMLWriter ]}:$out/lib/perl5/site_perl"
      '';
  };


  # Run an automated test suite in the given virtual network.
  # `driver' is the script that runs the network.
  runTests = driver:
    stdenv.mkDerivation {
      name = "vm-test-run";
      
      requiredSystemFeatures = [ "kvm" ];
      
      buildInputs = [ pkgs.libxslt ];

      buildCommand =
        ''
          mkdir -p $out/nix-support

          LOGFILE=$out/log.xml tests="testScript" ${driver}/bin/nixos-test-driver || failed=1

          # Generate a pretty-printed log.          
          xsltproc --output $out/log.html ${./test-driver/log2html.xsl} $out/log.xml
          ln -s ${./test-driver/logfile.css} $out/logfile.css
          ln -s ${./test-driver/treebits.js} $out/treebits.js
          ln -s ${pkgs.jquery_ui}/js/jquery.min.js $out/
          ln -s ${pkgs.jquery_ui}/js/jquery-ui.min.js $out/

          touch $out/nix-support/hydra-build-products
          echo "report testlog $out log.html" >> $out/nix-support/hydra-build-products

          for i in */coverage-data; do
            mkdir -p $out/coverage-data
            mv $i $out/coverage-data/$(dirname $i)
          done

          [ -z "$failed" ] || touch $out/nix-support/failed
        ''; # */
    };


  # Generate a coverage report from the coverage data produced by
  # runTests.
  makeReport = x: runCommand "report" { buildInputs = [rsync]; }
    ''
      mkdir -p $TMPDIR/gcov/

      for d in ${x}/coverage-data/*; do
          echo "doing $d"
          [ -n "$(ls -A "$d")" ] || continue

          for i in $(cd $d/nix/store && ls); do
              if ! test -e $TMPDIR/gcov/nix/store/$i; then
                  echo "copying $i"
                  mkdir -p $TMPDIR/gcov/$(echo $i | cut -c34-)
                  rsync -rv /nix/store/$i/.build/* $TMPDIR/gcov/
              fi
          done

          chmod -R u+w $TMPDIR/gcov

          find $TMPDIR/gcov -name "*.gcda" -exec rm {} \;

          for i in $(cd $d/nix/store && ls); do
              rsync -rv $d/nix/store/$i/.build/* $TMPDIR/gcov/
          done

          find $TMPDIR/gcov -name "*.gcda" -exec chmod 644 {} \;
          
          echo "producing info..."
          ${pkgs.lcov}/bin/geninfo --ignore-errors source,gcov $TMPDIR/gcov --output-file $TMPDIR/app.info
          cat $TMPDIR/app.info >> $TMPDIR/full.info
      done
            
      echo "making report..."
      mkdir -p $out/coverage
      ${pkgs.lcov}/bin/genhtml --show-details $TMPDIR/full.info -o $out/coverage
      cp $TMPDIR/full.info $out/coverage/

      mkdir -p $out/nix-support
      cat ${x}/nix-support/hydra-build-products >> $out/nix-support/hydra-build-products
      echo "report coverage $out/coverage" >> $out/nix-support/hydra-build-products
      [ ! -e ${x}/nix-support/failed ] || touch $out/nix-support/failed
    ''; # */


  makeTest = testFun: complete (call testFun);
  makeTests = testsFun: lib.mapAttrs (name: complete) (call testsFun);

  apply = makeTest; # compatibility
  call = f: f { inherit pkgs nixpkgs system; };

  complete = t: t // rec {
    nodes =
      if t ? nodes then t.nodes else
      if t ? machine then { machine = t.machine; }
      else { };
      
    vms = buildVirtualNetwork { inherit nodes; };
    
    testScript =
      # Call the test script with the computed nodes.
      if builtins.isFunction t.testScript
      then t.testScript { inherit (vms) nodes; }
      else t.testScript;
      
    # Generate a convenience wrapper for running the test driver
    # interactively with the specified network.
    driver = runCommand "nixos-test-driver"
      { buildInputs = [ makeWrapper];
        inherit testScript;
      }
      ''
        mkdir -p $out/bin
        echo "$testScript" > $out/test-script
        ln -s ${vms}/bin/* $out/bin/
        ln -s ${testDriver}/bin/* $out/bin/
        wrapProgram $out/bin/nixos-test-driver \
          --add-flags "${vms}/vms/*/bin/run-*-vm" \
          --run "testScript=\"\$(cat $out/test-script)\"" \
          --set testScript '"$testScript"' \
          --set VLANS '"${toString (map (m: m.config.virtualisation.vlans) (lib.attrValues vms.nodes))}"' \
      ''; # "

    test = runTests driver;
      
    report = makeReport test;
  };

  
  runInMachine =
    { drv
    , machine
    , preBuild ? ""
    , postBuild ? ""
    , ...
    }:
    let
      vms =
        buildVirtualNetwork { nodes = { client = machine; } ; };

      buildrunner = writeText "vm-build" ''
        source $1
 
        ${coreutils}/bin/mkdir -p $TMPDIR
        cd $TMPDIR
        
        $origBuilder $origArgs
         
        exit $?
      '';

      testscript = ''
        startAll;
        ${preBuild}
        print STDERR $client->mustSucceed("env -i ${pkgs.bash}/bin/bash ${buildrunner} /hostfs".$client->stateDir."/saved-env");
        ${postBuild}
      '';

      vmRunCommand = writeText "vm-run" ''
        ${coreutils}/bin/mkdir -p vm-state-client
        export > vm-state-client/saved-env
        export PATH=${qemu_kvm}/bin:${coreutils}/bin
        export tests='${testscript}'
        ${testDriver}/bin/nixos-test-driver ${vms}/vms/*/bin/run-*-vm
      ''; # */

    in
      lib.overrideDerivation drv (attrs: {
        requiredSystemFeatures = [ "kvm" ];
        builder = "${bash}/bin/sh";
        args = ["-e" vmRunCommand];
        origArgs = attrs.args;
        origBuilder = attrs.builder;   
      });

      
  runInMachineWithX = { require ? [], ...}@args :
    let
      client =
        { config, pkgs, ... }:
        {
          inherit require;
          virtualisation.memorySize = 1024;
          services.xserver.enable = true;
          services.xserver.displayManager.slim.enable = false;
          services.xserver.displayManager.auto.enable = true;
          services.xserver.windowManager.default = "icewm";
          services.xserver.windowManager.icewm.enable = true;
          services.xserver.desktopManager.default = "none";
        };
    in
      runInMachine ({
            machine = client;
            preBuild = ''
              $client->waitForX;
            '' ;
          } // args );   

          
  simpleTest = as: (makeTest ({ ... }: as)).test;

}
