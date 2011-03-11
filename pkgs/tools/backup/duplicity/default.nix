{ stdenv, fetchurl, python, librsync, gnupg, boto, makeWrapper }:

stdenv.mkDerivation {
  name = "duplicity-0.6.12";

  src = fetchurl {
    url = http://code.launchpad.net/duplicity/0.6-series/0.6.12/+download/duplicity-0.6.12.tar.gz;
    sha256 = "13ypzp8g3fmbxk7mixrj390vz6sgm93pg8gdw4bk9xrbznrw6shv";
  };

  installPhase = ''
    python setup.py install --prefix=$out
    wrapProgram $out/bin/duplicity \
      --prefix PYTHONPATH : "$(toPythonPath $out):$(toPythonPath ${boto})" \
      --prefix PATH : "${gnupg}/bin"
    wrapProgram $out/bin/rdiffdir \
      --prefix PYTHONPATH : "$(toPythonPath $out):$(toPythonPath ${boto})" \
  '';

  buildInputs = [ python librsync makeWrapper ];

  meta = {
    description = "Encrypted bandwidth-efficient backup using the rsync algorithm";
    homepage = http://www.nongnu.org/duplicity;
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
