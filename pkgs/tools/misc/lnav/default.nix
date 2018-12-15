{ stdenv, fetchFromGitHub, pcre-cpp, sqlite, ncurses
, readline, zlib, bzip2, autoconf, automake, curl }:

stdenv.mkDerivation rec {

  name = "lnav-${meta.version}";

  src = fetchFromGitHub {
    owner = "tstack";
    repo = "lnav";
    rev = "v${meta.version}";
    sha256 = "0wzzny0sgrq1ga9qw9nr8ly4j3vy4agszma73902dsw2rwf17j6y";
    inherit name;
  };

  buildInputs = [
    autoconf
    automake
    zlib
    bzip2
    ncurses
    pcre-cpp
    readline
    sqlite
    curl
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/tstack/lnav;
    description = "The Logfile Navigator";
    longDescription = ''
      The log file navigator, lnav, is an enhanced log file viewer that takes
      advantage of any semantic information that can be gleaned from the files
      being viewed, such as timestamps and log levels. Using this extra
      semantic information, lnav can do things like interleaving messages from
      different files, generate histograms of messages over time, and providing
      hotkeys for navigating through the file. It is hoped that these features
      will allow the user to quickly and efficiently zero in on problems.
    '';
    downloadPage = "https://github.com/tstack/lnav/releases";
    license = licenses.bsd2;
    version = "0.8.4";
    maintainers = [ maintainers.dochang ];
    platforms = platforms.unix;
  };

}
