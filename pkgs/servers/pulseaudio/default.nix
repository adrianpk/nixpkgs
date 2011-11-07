{ stdenv, fetchurl, pkgconfig, gnum4, gdbm, libtool, glib, dbus, avahi
, gconf, gtk, intltool, gettext
, alsaLib, libsamplerate, libsndfile, speex, bluez, udev
, jackaudioSupport ? false, jackaudio ? null
, x11Support ? false, xlibs
, xz, json_c
}:

assert jackaudioSupport -> jackaudio != null;

stdenv.mkDerivation rec {
  name = "pulseaudio-1.1";

  src = fetchurl {
    url = "http://freedesktop.org/software/pulseaudio/releases/pulseaudio-1.1.tar.xz";
    sha256 = "1vpm0681zj2jvhbabvnmrmfxr3172k4x58kjb39y5g3fdw9k3rbg";
  };

  # Since `libpulse*.la' contain `-lgdbm', it must be propagated.
  propagatedBuildInputs = [ gdbm ];

  buildInputs =
    [ pkgconfig gnum4 libtool intltool glib dbus avahi
      libsamplerate libsndfile speex alsaLib bluez udev
      xz json_c
      #gtk gconf 
    ]
    ++ stdenv.lib.optional jackaudioSupport jackaudio
    ++ stdenv.lib.optional x11Support xlibs.xlibs;

  preConfigure = ''
    # Change the `padsp' script so that it contains the full path to
    # `libpulsedsp.so'.
    sed -i "src/utils/padsp" \
        -e "s|libpulsedsp\.so|$out/lib/libpulsedsp.so|g"

    # Move the udev rules under $(prefix).
    sed -i "src/Makefile.in" \
        -e "s|udevrulesdir[[:blank:]]*=.*$|udevrulesdir = $out/lib/udev/rules.d|g"

   # don't install proximity-helper as root and setuid
   sed -i "src/Makefile.in" \
       -e "s|chown root|true |" \
       -e "s|chmod r+s |true |"
  '';

  configureFlags = ''
    --disable-solaris --disable-hal --disable-jack
    --disable-oss-output --disable-oss-wrapper
    --localstatedir=/var --sysconfdir=/etc
    ${if jackaudioSupport then "--enable-jack" else ""}
  '';

  installFlags = "pulseconfdir=$(out)/etc dbuspolicydir=$out/etc/dbus-1/system.d xdgautostartdir=$out/etc/xdg/autostart";

  enableParallelBuilding = true;

  meta = {
    description = "PulseAudio, a sound server for POSIX and Win32 systems";

    longDescription = ''
      PulseAudio is a sound server for POSIX and Win32 systems.  A
      sound server is basically a proxy for your sound applications.
      It allows you to do advanced operations on your sound data as it
      passes between your application and your hardware.  Things like
      transferring the audio to a different machine, changing the
      sample format or channel count and mixing several sounds into
      one are easily achieved using a sound server.
    '';

    homepage = http://www.pulseaudio.org/;

    # Note: Practically, the server is under the GPL due to the
    # dependency on `libsamplerate'.  See `LICENSE' for details.
    licenses = "LGPLv2+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.gnu;
  };
}
