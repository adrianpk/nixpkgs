{ stdenv
, fetchFromGitHub
, fetchpatch
}:
stdenv.mkDerivation rec {
  version = "8.4.rc0";
  name = "sage-src-${version}";

  src = fetchFromGitHub {
    owner = "sagemath";
    repo = "sage";
    rev = version;
    sha256 = "01115m0zvr6l33334bwpw7dcc2rdrpyx4mjfxqacfk5sii1zlkmm";
  };

  nixPatches = [
    # https://trac.sagemath.org/ticket/25358
    (fetchpatch {
      name = "safe-directory-test-without-patch.patch";
      url = "https://git.sagemath.org/sage.git/patch?id2=8bdc326ba57d1bb9664f63cf165a9e9920cc1afc&id=dc673c17555efca611f68398d5013b66e9825463";
      sha256 = "1hhannz7xzprijakn2w2d0rhd5zv2zikik9p51i87bas3nc658f7";
    })

    # Unfortunately inclusion in upstream sage was rejected. Instead the bug was
    # fixed in python, but of course not backported to 2.7. So we'll probably
    # have to keep this around until 2.7 is deprecated.
    # https://trac.sagemath.org/ticket/25316
    # https://github.com/python/cpython/pull/7476
    ./patches/python-5755-hotpatch.patch
  ];

  packageUpgradePatches = [
    # New glpk version has new warnings, filter those out until upstream sage has found a solution
    # https://trac.sagemath.org/ticket/24824
    ./patches/pari-stackwarn.patch # not actually necessary since tha pari upgrade, but necessary for the glpk patch to apply
    (fetchpatch {
      url = "https://salsa.debian.org/science-team/sagemath/raw/58bbba93a807ca2933ca317501d093a1bb4b84db/debian/patches/dt-version-glpk-4.65-ignore-warnings.patch";
      sha256 = "0b9293v73wb4x13wv5zwyjgclc01zn16msccfzzi6znswklgvddp";
      stripLen = 1;
    })

    # https://trac.sagemath.org/ticket/25260
    ./patches/numpy-1.15.1.patch

    # ntl upgrade
    (fetchpatch {
      name = "lcalc-c++11.patch";
      url = "https://git.archlinux.org/svntogit/community.git/plain/trunk/sagemath-lcalc-c++11.patch?h=packages/sagemath&id=0e31ae526ab7c6b5c0bfacb3f8b1c4fd490035aa";
      sha256 = "0p5wnvbx65i7cp0bjyaqgp4rly8xgnk12pqwaq3dqby0j2bk6ijb";
    })
  ];

  patches = nixPatches ++ packageUpgradePatches ++ [
    ./patches/known-padics-bug.patch
  ];

  postPatch = ''
    # make sure shebangs etc are fixed, but sage-python23 still works
    find . -type f -exec sed \
      -e 's/sage-python23/python/g' \
      -i {} \;

    echo '#!${stdenv.shell}
    python "$@"' > build/bin/sage-python23

    # Do not use sage-env-config (generated by ./configure).
    # Instead variables are set manually.
    echo '# do nothing' >  src/bin/sage-env-config
  '';

  configurePhase = "# do nothing";

  buildPhase = "# do nothing";

  installPhase = ''
    cp -r . "$out"
  '';
}
