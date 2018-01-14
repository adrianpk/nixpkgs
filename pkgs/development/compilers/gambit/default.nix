{ stdenv, fetchurl, fetchgit, git, openssl, autoconf, pkgs }:

# TODO: distinct packages for gambit-release and gambit-devel

stdenv.mkDerivation rec {
  name    = "gambit-${version}";
  version = "4.8.8-427-g37b111a5";
  bootstrap = import ./bootstrap.nix ( pkgs );

  src = fetchgit {
    url = "https://github.com/feeley/gambit.git";
    rev = "37b111a5ca3aeff9dc6cb8be470277a8c1e80f24";
    sha256 = "14l7jql9nh7bjs6c822a17rcp9583l6bb5kiq95allgyf229vy50";
  };

  buildInputs = [ openssl git autoconf bootstrap ];

  configurePhase = ''
    options=(
      --prefix=$out
      --enable-single-host
      --enable-c-opt=-O2
      --enable-gcc-opts
      --enable-shared
      --enable-absolute-shared-libs # Yes, NixOS will want an absolute path, and fix it.
      --enable-poll
      --enable-openssl
      --enable-default-runtime-options="f8,-8,t8" # Default to UTF-8 for source and all I/O
      #--enable-debug # Nope: enables plenty of good stuff, but also the costly console.log

      #--enable-multiple-versions # Nope, NixOS already does version multiplexing
      #--enable-guide
      #--enable-track-scheme
      #--enable-high-res-timing
      #--enable-max-processors=4
      #--enable-multiple-vms
      #--enable-dynamic-tls
      #--enable-multiple-vms
      #--enable-multiple-threaded-vms  ## when SMP branch is merged in
      #--enable-thread-system=posix    ## default when --enable-multiple-vms is on.
      #--enable-profile
      #--enable-coverage
      #--enable-inline-jumps
      #--enable-char-size=1" ; default is 4
    )
    ./configure ''${options[@]}
  '';

  buildPhase = ''
    # Make bootstrap compiler, from release bootstrap
    mkdir -p boot &&
    cp -rp ${bootstrap}/. boot/. &&
    chmod -R u+w boot &&
    cd boot &&
    cp ../gsc/makefile.in ../gsc/*.scm gsc && # */
    ./configure &&
    for i in lib gsi gsc ; do (cd $i ; make ) ; done &&
    cd .. &&
    cp boot/gsc/gsc gsc-boot &&

    # Now use the bootstrap compiler to build the real thing!
    make -j2 from-scratch
  '';

  doCheck = true;

  meta = {
    description = "Optimizing Scheme to C compiler";
    homepage    = "http://gambitscheme.org";
    license     = stdenv.lib.licenses.lgpl2;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice raskin fare ];
  };
}
