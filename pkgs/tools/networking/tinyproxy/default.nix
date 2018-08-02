{ stdenv, fetchFromGitHub, automake, autoreconfHook, asciidoc, libxml2, libxslt }:

stdenv.mkDerivation rec{
  name = "tinyproxy-${version}";
  version = "1.8.4";

  src = fetchFromGitHub {
    sha256 = "043mfqin5bsba9igm1lqbkp2spibk4j3niyjqc868cnzgx60709c";
    rev = "${version}";
    repo = "tinyproxy";
    owner = "tinyproxy";
  };

  nativeBuildInputs = [ autoreconfHook asciidoc libxml2 libxslt ];

  # -z flag is not supported in darwin
  preAutoreconf = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace configure.ac --replace \
          'LDFLAGS="-Wl,-z,defs $LDFLAGS"' \
          'LDFLAGS="-Wl, $LDFLAGS"'
  '';

  # See: https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=154624
  postConfigure = ''
    substituteInPlace docs/man5/Makefile --replace \
          "-f manpage" \
          "-f manpage \\
           -L"
    substituteInPlace docs/man8/Makefile --replace \
          "-f manpage" \
          "-f manpage \\
           -L"
  '';

  configureFlags = [
    "--disable-debug"      # Turn off debugging
    "--enable-xtinyproxy"  # Compile in support for the XTinyproxy header, which is sent to any web server in your domain.
    "--enable-filter"      # Allows Tinyproxy to filter out certain domains and URLs.
    "--enable-upstream"    # Enable support for proxying connections through another proxy server.
    "--enable-transparent" # Allow Tinyproxy to be used as a transparent proxy daemon.
    "--enable-reverse"     # Enable reverse proxying.
  ] ++
  # See: https://github.com/tinyproxy/tinyproxy/issues/1
  stdenv.lib.optional stdenv.isDarwin "--disable-regexcheck";

  meta = with stdenv.lib; {
    homepage = https://tinyproxy.github.io/;
    description = "A light-weight HTTP/HTTPS proxy daemon for POSIX operating systems";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.carlosdagos ];
  };
}
