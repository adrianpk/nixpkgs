{ stdenv
, fetchFromGitHub
, fetchpatch
}:
stdenv.mkDerivation rec {
  version = "8.3";
  name = "sage-src-${version}";

  src = fetchFromGitHub {
    owner = "sagemath";
    repo = "sage";
    rev = version;
    sha256 = "0mbm99m5xry21xpi4q3q96gx392liwbifywf5awvl0j85a7rkfyx";
  };

  nixPatches = [
    # https://trac.sagemath.org/ticket/25809
    ./patches/spkg-scripts.patch

    # https://trac.sagemath.org/ticket/25309
    (fetchpatch {
      name = "spkg-paths.patch";
      url = "https://git.sagemath.org/sage.git/patch/?h=97f06fddee920399d4fcda65aa9b0925774aec69&id=a86151429ccce1ddd085e8090ada8ebdf02f3310";
      sha256 = "1xb9108rzzkdhn71vw44525620d3ww9jv1fph5a77v9y7nf9wgr7";
    })
    (fetchpatch {
      name = "maxima-fas.patch";
      url = "https://git.sagemath.org/sage.git/patch/?h=97f06fddee920399d4fcda65aa9b0925774aec69";
      sha256 = "14s50yg3hpw9cp3v581dx7zfmpm2j972im7x30iwki8k45mjvk3i";
    })

    # https://trac.sagemath.org/ticket/25722
    ./patches/test-in-tmpdir.patch

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

    # https://trac.sagemath.org/ticket/25315
    (fetchpatch {
      name = "find-libraries-in-dyld-library-path.patch";
      url = "https://git.sagemath.org/sage.git/patch/?h=20d4593876ce9c6004eac2ab6fd61786d0d96a06";
      sha256 = "1k3afq3qlzmgqwx6rzs5wv153vv9dsf5rk8pi61g57l3r3npbjmc";
    })

    # Pari upstream has since accepted a patch, so this patch won't be necessary once sage updates pari.
    # https://trac.sagemath.org/ticket/25312
    ./patches/pari-stackwarn.patch

    # https://trac.sagemath.org/ticket/25345
    # (upstream patch doesn't apply on 8.2 source)
    ./patches/dochtml-optional.patch
  ];

  packageUpgradePatches = [
    (fetchpatch {
      name = "cypari2-1.2.1.patch";
      url = "https://git.sagemath.org/sage.git/patch/?h=62fe6eb15111327d930336d4252d5b23cbb22ab9";
      sha256 = "1xax7vvs8h4xip16xcsp47xdb6lig6f2r3pl8cksvlz8lhgbyxh2";
    })

    # matplotlib 2.2.2 deprecated `normed` (replaced by `density`).
    # This patch only ignores the warning. It would be equally easy to fix it
    # (by replacing all mentions of `normed` by `density`), but its better to
    # stay close to sage upstream. I didn't open an upstream ticket about it
    # because the matplotlib update also requires a new dependency (kiwisolver)
    # and I don't want to invest the time to learn how to add it.
    ./patches/matplotlib-normed-deprecated.patch

    # Update to 20171219 broke the doctests because of insignificant precision
    # changes, make the doctests less fragile.
    # I didn't open an upstream ticket because its not entirely clear if
    # 20171219 is really "released" yet. It is listed on the github releases
    # page, but not marked as "latest release" and the homepage still links to
    # the last version.
    ./patches/eclib-regulator-precision.patch

    # New glpk version has new warnings, filter those out until upstream sage has found a solution
    # https://trac.sagemath.org/ticket/24824
    (fetchpatch {
      url = "https://salsa.debian.org/science-team/sagemath/raw/58bbba93a807ca2933ca317501d093a1bb4b84db/debian/patches/dt-version-glpk-4.65-ignore-warnings.patch";
      sha256 = "0b9293v73wb4x13wv5zwyjgclc01zn16msccfzzi6znswklgvddp";
      stripLen = 1;
    })

    # Only formatting changes.
    # https://trac.sagemath.org/ticket/25260
    ./patches/numpy-1.14.3.patch

    # https://trac.sagemath.org/ticket/25862
    ./patches/eclib-20180710.patch

    # https://trac.sagemath.org/ticket/24735
    ./patches/singular-4.1.1p2.patch
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
