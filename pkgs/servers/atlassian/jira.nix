{ stdenv, lib, fetchurl
, enableSSO ? false
, crowdProperties ? null
}:

stdenv.mkDerivation rec {
  name = "atlassian-jira-${version}";
  version = "7.11.1";

  src = fetchurl {
    url = "https://downloads.atlassian.com/software/jira/downloads/atlassian-jira-software-${version}.tar.gz";
    sha256 = "0zcpxh8713f0v4jmczcvsnqjjvlmrmc0d76mkivn0b294z2s8sp4";
  };

  phases = [ "unpackPhase" "buildPhase" "installPhase" "fixupPhase" ];

  buildPhase = ''
    mv conf/server.xml conf/server.xml.dist
    ln -sf /run/atlassian-jira/server.xml conf/server.xml
    rm -r logs; ln -sf /run/atlassian-jira/logs/ .
    rm -r work; ln -sf /run/atlassian-jira/work/ .
    rm -r temp; ln -sf /run/atlassian-jira/temp/ .
  '' + lib.optionalString enableSSO ''
    substituteInPlace atlassian-jira/WEB-INF/classes/seraph-config.xml \
      --replace com.atlassian.jira.security.login.JiraSeraphAuthenticator \
                com.atlassian.jira.security.login.SSOSeraphAuthenticator
  '' + lib.optionalString (crowdProperties != null) ''
    cat <<EOF > atlassian-jira/WEB-INF/classes/crowd.properties
    ${crowdProperties}
    EOF
  '';

  installPhase = ''
    cp -rva . $out
  '';

  meta = with stdenv.lib; {
    description = "Proprietary issue tracking product, also providing project management functions";
    homepage = https://www.atlassian.com/software/jira;
    license = licenses.unfree;
    maintainers = with maintainers; [ fpletz globin ciil ];
  };
}
