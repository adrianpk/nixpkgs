{ stdenv, targetPlatform, fetchurl, buildPythonApplication
, zip, ffmpeg, rtmpdump, phantomjs2, atomicparsley, pycryptodome, pandoc
# Pandoc is required to build the package's man page. Release tarballs contain a
# formatted man page already, though, it will still be installed. We keep the
# manpage argument in place in case someone wants to use this derivation to
# build a Git version of the tool that doesn't have the formatted man page
# included.
, generateManPage ? false
, ffmpegSupport ? true
, rtmpSupport ? true
, phantomjsSupport ? false
, hlsEncryptedSupport ? true
, makeWrapper }:

with stdenv.lib;
buildPythonApplication rec {

  pname = "youtube-dl";
  version = "2018.05.18";

  src = fetchurl {
    url = "https://yt-dl.org/downloads/${version}/${pname}-${version}.tar.gz";
    sha256 = "11r0hv6885w8k4m307kvf9545vr5a3ym9bf7szghvbcgmgc8lm5w";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ zip ] ++ optional generateManPage pandoc;
  propagatedBuildInputs = optional hlsEncryptedSupport pycryptodome;

  # Ensure ffmpeg is available in $PATH for post-processing & transcoding support.
  # rtmpdump is required to download files over RTMP
  # atomicparsley for embedding thumbnails
  makeWrapperArgs = let
      packagesToBinPath =
        [ atomicparsley ]
        ++ optional ffmpegSupport ffmpeg
        ++ optional rtmpSupport rtmpdump
        ++ optional phantomjsSupport phantomjs2;
    in [ ''--prefix PATH : "${makeBinPath packagesToBinPath}"'' ];

  postInstall = ''
    mkdir -p $out/share/zsh/site-functions
    cp youtube-dl.zsh $out/share/zsh/site-functions/_youtube-dl
  '';

  # Requires network
  doCheck = false;

  meta = {
    homepage = https://rg3.github.io/youtube-dl/;
    repositories.git = https://github.com/rg3/youtube-dl.git;
    description = "Command-line tool to download videos from YouTube.com and other sites";
    longDescription = ''
      youtube-dl is a small, Python-based command-line program
      to download videos from YouTube.com and a few more sites.
      youtube-dl is released to the public domain, which means
      you can modify it, redistribute it or use it however you like.
    '';
    license = licenses.publicDomain;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ bluescreen303 phreedom AndersonTorres fuuzetsu fpletz ];
  };
}
