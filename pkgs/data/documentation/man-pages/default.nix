{ stdenv, fetchurl }:

let version = "4.04"; in
stdenv.mkDerivation rec {
  name = "man-pages-${version}";

  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/${name}.tar.xz";
    sha256 = "0v8zxq4scfixy3pjpw9ankvv5v8frv62khv4xm1jpkswyq6rbqcg";
  };

  makeFlags = [ "MANDIR=$(out)/share/man" ];

  meta = with stdenv.lib; {
    inherit version;
    description = "Linux development manual pages";
    homepage = http://www.kernel.org/doc/man-pages/;
    repositories.git = http://git.kernel.org/pub/scm/docs/man-pages/man-pages;
    maintainers = with maintainers; [ nckx ];
  };
}
