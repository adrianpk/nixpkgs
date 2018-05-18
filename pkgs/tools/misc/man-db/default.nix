{ stdenv, fetchurl, pkgconfig, libpipeline, db, groff, libiconv, makeWrapper, buildPackages }:

stdenv.mkDerivation rec {
  name = "man-db-2.7.5";

  src = fetchurl {
    url = "mirror://savannah/man-db/${name}.tar.xz";
    sha256 = "056a3il7agfazac12yggcg4gf412yq34k065im0cpfxbcw6xskaw";
  };

  outputs = [ "out" "doc" ];
  outputMan = "out"; # users will want `man man` to work

  nativeBuildInputs = [ pkgconfig makeWrapper groff ]
    ++ stdenv.lib.optionals doCheck checkInputs;
  buildInputs = [ libpipeline db groff ]; # (Yes, 'groff' is both native and build input)
  checkInputs = [ libiconv /* for 'iconv' binary */ ];

  postPatch = ''
    substituteInPlace src/man_db.conf.in \
      --replace "/usr/local/share" "/run/current-system/sw/share" \
      --replace "/usr/share" "/run/current-system/sw/share"
  '';

  configureFlags = [
    "--disable-setuid"
    "--localstatedir=/var"
    # Don't try /etc/man_db.conf by default, so we avoid error messages.
    "--with-config-file=\${out}/etc/man_db.conf"
    "--with-systemdtmpfilesdir=\${out}/lib/tmpfiles.d"
  ];

  preConfigure = ''
    configureFlagsArray+=("--with-sections=1 n l 8 3 0 2 5 4 9 6 7")
  '';

  postInstall = ''
    # apropos/whatis uses program name to decide whether to act like apropos or whatis
    # (multi-call binary). `apropos` is actually just a symlink to whatis. So we need to
    # make sure that we don't wrap symlinks (since that changes argv[0] to the -wrapped name)
    find "$out/bin" -type f | while read file; do
      wrapProgram "$file" --prefix PATH : "${groff}/bin"
    done
  '';

  postFixup = stdenv.lib.optionalString (buildPackages.groff != groff) ''
    # Check to make sure none of the outputs depend on build-time-only groff:
    for outName in $outputs; do
      out=''${!outName}
      echo "Checking $outName(=$out) for references to build-time groff..."
      if grep -r '${buildPackages.groff}' $out; then
        echo "Found an erroneous dependency on groff ^^^" >&2
        exit 1
      fi
    done
  '';

  enableParallelBuilding = true;

  doCheck = !stdenv.hostPlatform.isMusl; /* iconv binary */

  meta = with stdenv.lib; {
    homepage = http://man-db.nongnu.org;
    description = "An implementation of the standard Unix documentation system accessed using the man command";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
