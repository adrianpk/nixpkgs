#! /bin/sh -e
. $stdenv/setup
dontMake=1
dontMakeInstall=1
nop() {
    sourceRoot=.
}
unpackPhase=nop
genericBuild
