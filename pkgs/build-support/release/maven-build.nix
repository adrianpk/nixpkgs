{ stdenv
, name
, src
, doTest ? true
, doTestCompile ? true
, doJavadoc ? false
, doCheckstyle ? false
, doRelease ? false
, includeTestClasses ? true
, extraMvnFlags ? ""
, ...
} @ args :

let 
  mvnFlags = "-Dmaven.repo.local=$M2_REPO ${if doTest then "" else "-Dmaven.test.skip.exec=true"} ${extraMvnFlags}";
in

stdenv.mkDerivation ( rec {
  inherit name src; 
  phases = "setupPhase unpackPhase patchPhase mvnCompile ${if doTestCompile then "mvnTestCompile mvnTestJar" else ""} ${if doTest then "mvnTest" else ""} ${if doJavadoc then "mvnJavadoc" else ""} ${if doCheckstyle then "mvnCheckstyle" else ""} mvnJar mvnAssembly mvnRelease finalPhase";

  setupPhase = ''
    runHook preSetupPhase

    mkdir -p $out/nix-support
    export LANG="en_US.UTF-8"
    export LOCALE_ARCHIVE=$glibcLocales/lib/locale/locale-archive
    export M2_REPO=$TMPDIR/repository

    runHook postSetupPhase
  '';

  mvnCompile = ''
    mvn compile ${mvnFlags}
  '';  

  mvnTestCompile = ''
    mvn test-compile ${mvnFlags}
  '';  

  mvnTestJar = ''
    mvn jar:test-jar ${mvnFlags}
  '';  

  mvnTest = ''
    mvn test ${mvnFlags}

    if [ -d target/site/cobertura ] ; then
      echo "report coverage $out/site/cobertura" >> $out/nix-support/hydra-build-products
    fi

    if [ -d target/surefire-reports ] ; then
      mvn surefire-report:report-only
      echo "report coverage $out/site/surefire-report.html" >> $out/nix-support/hydra-build-products
    fi
  '';  

  mvnJavadoc = ''
    mvn javadoc:javadoc ${mvnFlags}
    echo "report javadoc $out/site/apidocs" >> $out/nix-support/hydra-build-products
  '';  

  mvnCheckstyle = ''
    mvn checkstyle:checkstyle ${mvnFlags}
    echo "report checkstyle $out/site/checkstyle.html" >> $out/nix-support/hydra-build-products
  '';  

  mvnJar = ''
    mvn jar:jar ${mvnFlags}
  '';  

  mvnAssembly = ''
    mvn assembly:assembly -Dmaven.test.skip.exec=true ${mvnFlags}
  '';

  mvnRelease = ''
    mkdir -p $out/release

    zip=$(ls target/*.zip| head -1)
    releaseName=$(basename $zip .zip)
    releaseName="$releaseName-r${toString src.rev or "0"}"
    cp $zip $out/release/$releaseName.zip
    
    echo "$releaseName" > $out/nix-support/hydra-release-name

    ${if doRelease then  ''
    echo "file zip $out/release/$releaseName.zip" >> $out/nix-support/hydra-build-products
    '' else ""}
  '';  

  finalPhase = ''
    if [ -d target/site ] ; then
      cp -R target/site $out/
      echo "report site $out/site" >> $out/nix-support/hydra-build-products
    fi
  '';
} // args 
)
