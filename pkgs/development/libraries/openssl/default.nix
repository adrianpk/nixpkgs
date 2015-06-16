{ stdenv, fetchurl, perl
, withCryptodev ? false, cryptodevHeaders }:

let
  name = "openssl-1.0.1o";

  opensslCrossSystem = stdenv.lib.attrByPath [ "openssl" "system" ]
    (throw "openssl needs its platform name cross building" null)
    stdenv.cross;

  patchesCross = isCross: let
    isDarwin = stdenv.isDarwin || (isCross && stdenv.cross.libc == "libSystem");
  in stdenv.lib.optional isDarwin ./darwin-arch.patch;

  extraPatches = stdenv.lib.optional stdenv.isCygwin ./1.0.1-cygwin64.patch;
in

stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    urls = [
      "http://www.openssl.org/source/${name}.tar.gz"
      "http://openssl.linux-mirror.org/source/${name}.tar.gz"
    ];
    sha1 = "b003e3382607ef2c6d85b51e4ed7a4c0a76b8d5a";
  };

  patches = (patchesCross false) ++ extraPatches;

  buildInputs = stdenv.lib.optional withCryptodev cryptodevHeaders;

  nativeBuildInputs = [ perl ];

  # On x86_64-darwin, "./config" misdetects the system as
  # "darwin-i386-cc".  So specify the system type explicitly.
  configureScript =
    if stdenv.system == "x86_64-darwin" then "./Configure darwin64-x86_64-cc"
    else if stdenv.system == "x86_64-solaris" then "./Configure solaris64-x86_64-gcc"
    else "./config";

  configureFlags = "shared --libdir=lib --openssldir=etc/ssl" +
    stdenv.lib.optionalString withCryptodev " -DHAVE_CRYPTODEV -DUSE_CRYPTODEV_DIGESTS";

  # CYGXXX: used to be set for cygwin with optionalString. Not needed
  # anymore but kept to prevent rebuild.
  preBuild = "";

  makeFlags = "MANDIR=$(out)/share/man";

  # Parallel building is broken in OpenSSL.
  enableParallelBuilding = false;

  postInstall =
    ''
      # If we're building dynamic libraries, then don't install static
      # libraries.
      if [ -n "$(echo $out/lib/*.so $out/lib/*.dylib)" ]; then
          rm $out/lib/*.a
      fi

      # remove dependency on Perl at runtime
      rm -rf $out/etc/ssl/misc
    ''; # */

  crossAttrs = {
    patches = patchesCross true;

    preConfigure=''
      # It's configure does not like --build or --host
      export configureFlags="--libdir=lib --cross-compile-prefix=${stdenv.cross.config}- shared ${opensslCrossSystem}"
    '';

    postInstall = ''
      # Openssl installs readonly files, which otherwise we can't strip.
      # This could at some stdenv hash change be put out of crossAttrs, too
      chmod -R +w $out

      # Remove references to perl, to avoid depending on it at runtime
      rm $out/bin/c_rehash $out/ssl/misc/CA.pl $out/ssl/misc/tsget
    '';
    configureScript = "./Configure";
  } // stdenv.lib.optionalAttrs (opensslCrossSystem == "darwin64-x86_64-cc") {
    CC = "gcc";
  };

  meta = {
    homepage = http://www.openssl.org/;
    description = "A cryptographic library that implements the SSL and TLS protocols";
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.simons ];
    priority = 10; # resolves collision with ‘man-pages’
  };
}
