{ stdenv, lib, fetchurl, ncurses, xlibsWrapper, libXaw, libXpm, Xaw3d
, pkgconfig, gettext, libXft, dbus, libpng, libjpeg, libungif
, libtiff, librsvg, gconf, libxml2, imagemagick, gnutls, libselinux
, alsaLib, cairo, acl, gpm, AppKit, CoreWLAN, Kerberos, GSS, ImageIO
, withX ? !stdenv.isDarwin
, withGTK2 ? false, gtk2 ? null
, withGTK3 ? true, gtk3 ? null, gsettings_desktop_schemas ? null
, withXwidgets ? false, webkitgtk24x ? null, wrapGAppsHook ? null, glib_networking ? null
, withCsrc ? true
, srcRepo ? false, autoconf ? null, automake ? null, texinfo ? null
}:

assert (libXft != null) -> libpng != null;      # probably a bug
assert stdenv.isDarwin -> libXaw != null;       # fails to link otherwise
assert withGTK2 -> withX || stdenv.isDarwin;
assert withGTK3 -> withX || stdenv.isDarwin;
assert withGTK2 -> !withGTK3 && gtk2 != null;
assert withGTK3 -> !withGTK2 && gtk3 != null;
assert withXwidgets -> withGTK3 && webkitgtk24x != null;

let
  toolkit =
    if withGTK2 then "gtk2"
    else if withGTK3 then "gtk3"
    else "lucid";
in
stdenv.mkDerivation rec {
  name = "emacs-${version}${versionModifier}";
  version = "25.1";
  versionModifier = "";

  src = fetchurl {
    url = "mirror://gnu//emacs/${name}.tar.xz";
    sha256 = "0cwgyiyymnx4xdg99dm2drfxcyhy2jmyf0rkr9fwj9mwwf77kwhr";
  };

  patches = (lib.optional stdenv.isDarwin ./at-fdcwd.patch) ++ [
    ## Fixes a segfault in emacs 25.1
    ## http://lists.gnu.org/archive/html/emacs-devel/2016-10/msg00917.html
    ## https://debbugs.gnu.org/cgi/bugreport.cgi?bug=24358
    (fetchurl {
      url = http://git.savannah.gnu.org/cgit/emacs.git/patch/?id=9afea93ed536fb9110ac62b413604cf4c4302199;
      sha256 = "0pshhq8wlh98m9hm8xd3g7gy3ms0l44dq6vgzkg67ydlccziqz40"; })
    (fetchurl {
      url = http://git.savannah.gnu.org/cgit/emacs.git/patch/?id=71ca4f6a43bad06192cbc4bb8c7a2d69c179b7b0;
      sha256 = "0h76wrrqyrky441immprskx5x7200zl7ajf7hyg4da22q7sr09qa"; })
    (fetchurl {
      url = http://git.savannah.gnu.org/cgit/emacs.git/patch/?id=1047496722a58ef5b736dae64d32adeb58c5055c;
      sha256 = "0hk9pi3f2zj266qj8armzpl0z8rfjg0m9ss4k09mgg1hyz80wdvv"; })
    (fetchurl {
      url = http://git.savannah.gnu.org/cgit/emacs.git/patch/?id=96ac0c3ebce825e60595794f99e703ec8302e240;
      sha256 = "1q2hqkjvj9z46b5ik56lv9wiibz09mvg2q3pn8fnpa04ki3zbh4x"; })
    (fetchurl {
      url = http://git.savannah.gnu.org/cgit/emacs.git/patch/?id=43986d16fb6ad78a627250e14570ea70bdb1f23a;
      sha256 = "1wlyy04qahvls7bdrcxaazh9k27gksk7if1q58h83f7h6g9xxkzj";
    })
  ];

  nativeBuildInputs = [ pkgconfig ]
    ++ lib.optionals srcRepo [ autoconf automake texinfo ]
    ++ lib.optional (withX && (withGTK3 || withXwidgets)) wrapGAppsHook;

  buildInputs =
    [ ncurses gconf libxml2 gnutls alsaLib acl gpm gettext ]
    ++ lib.optionals stdenv.isLinux [ dbus libselinux ]
    ++ lib.optionals withX
      [ xlibsWrapper libXaw Xaw3d libXpm libpng libjpeg libungif libtiff librsvg libXft
        imagemagick gconf ]
    ++ lib.optional (withX && withGTK2) gtk2
    ++ lib.optionals (withX && withGTK3) [ gtk3 gsettings_desktop_schemas ]
    ++ lib.optional (stdenv.isDarwin && withX) cairo
    ++ lib.optionals (withX && withXwidgets) [ webkitgtk24x glib_networking ];

  propagatedBuildInputs = lib.optionals stdenv.isDarwin [ AppKit GSS ImageIO ];

  hardeningDisable = [ "format" ];

  configureFlags = [ "--with-modules" ] ++
   (if stdenv.isDarwin
      then [ "--with-ns" "--disable-ns-self-contained" ]
    else if withX
      then [ "--with-x-toolkit=${toolkit}" "--with-xft" ]
      else [ "--with-x=no" "--with-xpm=no" "--with-jpeg=no" "--with-png=no"
             "--with-gif=no" "--with-tiff=no" ])
    ++ lib.optional withXwidgets "--with-xwidgets";

  preConfigure = lib.optionalString srcRepo ''
    ./autogen.sh
  '' + ''
    substituteInPlace lisp/international/mule-cmds.el \
      --replace /usr/share/locale ${gettext}/share/locale

    for makefile_in in $(find . -name Makefile.in -print); do
        substituteInPlace $makefile_in --replace /bin/pwd pwd
    done
  '';

  installTargets = "tags install";

  postInstall = ''
    mkdir -p $out/share/emacs/site-lisp
    cp ${./site-start.el} $out/share/emacs/site-lisp/site-start.el
    $out/bin/emacs --batch -f batch-byte-compile $out/share/emacs/site-lisp/site-start.el

    rm -rf $out/var
    rm -rf $out/share/emacs/${version}/site-lisp
  '' + lib.optionalString withCsrc ''
    for srcdir in src lisp lwlib ; do
      dstdir=$out/share/emacs/${version}/$srcdir
      mkdir -p $dstdir
      find $srcdir -name "*.[chm]" -exec cp {} $dstdir \;
      cp $srcdir/TAGS $dstdir
      echo '((nil . ((tags-file-name . "TAGS"))))' > $dstdir/.dir-locals.el
    done
  '' + lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    mv nextstep/Emacs.app $out/Applications
  '';

  meta = with stdenv.lib; {
    description = "The extensible, customizable GNU text editor";
    homepage    = http://www.gnu.org/software/emacs/;
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ chaoflow lovek323 peti the-kenny jwiegley ];
    platforms   = platforms.all;

    longDescription = ''
      GNU Emacs is an extensible, customizable text editor—and more.  At its
      core is an interpreter for Emacs Lisp, a dialect of the Lisp
      programming language with extensions to support text editing.

      The features of GNU Emacs include: content-sensitive editing modes,
      including syntax coloring, for a wide variety of file types including
      plain text, source code, and HTML; complete built-in documentation,
      including a tutorial for new users; full Unicode support for nearly all
      human languages and their scripts; highly customizable, using Emacs
      Lisp code or a graphical interface; a large number of extensions that
      add other functionality, including a project planner, mail and news
      reader, debugger interface, calendar, and more.  Many of these
      extensions are distributed with GNU Emacs; others are available
      separately.
    '';
  };
}
