{ stdenv, fetchurl, ncurses, x11, libXaw, libXpm, Xaw3d
, pkgconfig, gtk, libXft, dbus, libpng, libjpeg, libungif
, libtiff, librsvg, texinfo, gconf, libxml2, imagemagick, gnutls
, alsaLib, cairo
, withX ? !stdenv.isDarwin, withGTK ? true
}:

assert (libXft != null) -> libpng != null;	# probably a bug
assert stdenv.isDarwin -> libXaw != null;	# fails to link otherwise

stdenv.mkDerivation rec {
  name = "emacs-24.3";

  builder = ./builder.sh;

  src = fetchurl {
    url    = "mirror://gnu/emacs/${name}.tar.xz";
    sha256 = "1385qzs3bsa52s5rcncbrkxlydkw0ajzrvfxgv8rws5fx512kakh";
  };

  patches = [ ./darwin-new-sections.patch ];

  buildInputs =
    [ ncurses gconf libxml2 gnutls alsaLib pkgconfig texinfo ]
    ++ stdenv.lib.optional stdenv.isLinux dbus
    ++ stdenv.lib.optionals withX
      [ x11 libXaw Xaw3d libXpm libpng libjpeg libungif libtiff librsvg libXft
        imagemagick gtk gconf ]
    ++ stdenv.lib.optional (stdenv.isDarwin && withX) cairo;

  configureFlags =
    ( if withX && withGTK then
        [ "--with-x-toolkit=gtk" "--with-xft"]
      else (if withX then
        [ "--with-x-toolkit=lucid" "--with-xft" ]
      else
        [ "--with-x=no" "--with-xpm=no" "--with-jpeg=no" "--with-png=no"
          "--with-gif=no" "--with-tiff=no" ] ) )
    # On NixOS, help Emacs find `crt*.o'.
    ++ stdenv.lib.optional (stdenv ? glibc)
         [ "--with-crt-dir=${stdenv.glibc}/lib" ];

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString (stdenv.isDarwin && withX)
    "-I${cairo}/include/cairo";

  postInstall = ''
    cat >$out/share/emacs/site-lisp/site-start.el <<EOF
    ;; nixos specific load-path
    (when (getenv "NIX_PROFILES") (setq load-path
                          (append (reverse (mapcar (lambda (x) (concat x "/share/emacs/site-lisp/"))
                                                   (split-string (getenv "NIX_PROFILES"))))
                           load-path)))
        
    ;; make tramp work for NixOS machines
    (eval-after-load 'tramp '(add-to-list 'tramp-remote-path "/run/current-system/sw/bin"))
    EOF
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    description = "GNU Emacs 24, the extensible, customizable text editor";
    homepage    = http://www.gnu.org/software/emacs/;
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ chaoflow lovek323 simons the-kenny ];
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
