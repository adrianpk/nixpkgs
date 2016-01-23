if [[ -z "$QMAKE" ]]; then

linkDependencyDir() {
    @lndir@/bin/lndir -silent "$1/$2" "$qtOut/$2"
    if [[ -n "$NIX_QT_SUBMODULE" ]]; then
        find "$1/$2" -printf "$2/%P\n" >> "$out/nix-support/qt-inputs"
    fi
}

addQtModule() {
    if [[ -d "$1/mkspecs" ]]; then
        # $1 is a Qt module
        linkDependencyDir "$1" mkspecs

        for dir in bin include lib share; do
            if [[ -d "$1/$dir" ]]; then
                linkDependencyDir "$1" "$dir"
            fi
        done
    fi
}

propagateRuntimeDeps() {
    local propagated
    for dir in "etc/xdg" "lib/qt5/plugins" "lib/qt5/qml" "lib/qt5/imports" "share"; do
        if [[ -d "$1/$dir" ]]; then
            propagated=
            for pkg in $propagatedBuildInputs; do
                if [[ "z$pkg" == "z$1" ]]; then
                    propagated=1
                    break
                fi
            done
            if [[ -z $propagated ]]; then
                propagatedBuildInputs="$propagatedBuildInputs $1"
            fi
            break
        fi
    done
}

rmQtModules() {
    cat "$out/nix-support/qt-inputs" | while read file; do
      if [[ -h "$out/$file" ]]; then
        rm "$out/$file"
      fi
    done

    cat "$out/nix-support/qt-inputs" | while read file; do
      if [[ -d "$out/$file" ]]; then
        rmdir --ignore-fail-on-non-empty -p "$out/$file"
      fi
    done

    rm "$out/nix-support/qt-inputs"
}

rmQMake() {
    rm "$qtOut/bin/qmake" "$qtOut/bin/qt.conf"
}

setQMakePath() {
    export PATH="$qtOut/bin${PATH:+:}$PATH"
}

_multioutQtModuleDevs() {
    # We cannot simply set these paths in configureFlags because libQtCore retains
    # references to the paths it was built with.
    moveToOutput "bin" "${!outputDev}"
    moveToOutput "include" "${!outputDev}"

    # The destination directory must exist or moveToOutput will do nothing
    mkdir -p "${!outputDev}/share"
    moveToOutput "share/doc" "${!outputDev}"
}

_multioutQtDevs() {
    # This is necessary whether the package is a Qt module or not
    moveToOutput "mkspecs" "${!outputDev}"
}

qtOut=""
if [[ -z "$NIX_QT_SUBMODULE" ]]; then
    qtOut=`mktemp -d`
else
    qtOut=$out
fi

mkdir -p "$qtOut/bin" "$qtOut/mkspecs" "$qtOut/include" "$qtOut/nix-support" "$qtOut/lib" "$qtOut/share"

cp "@dev@/bin/qmake" "$qtOut/bin"
cat >"$qtOut/bin/qt.conf" <<EOF
[Paths]
Prefix = $qtOut
Plugins = lib/qt5/plugins
Imports = lib/qt5/imports
Qml2Imports = lib/qt5/qml
Documentation = share/doc/qt5
EOF

export QMAKE="$qtOut/bin/qmake"

envHooks+=(addQtModule propagateRuntimeDeps)
# Set PATH to find qmake first in a preConfigure hook
# It must run after all the envHooks!
preConfigureHooks+=(setQMakePath)

preFixupHooks+=(_multioutQtDevs)
if [[ -n "$NIX_QT_SUBMODULE" ]]; then
    postInstallHooks+=(rmQMake rmQtModules)
    preFixupHooks+=(_multioutQtModuleDevs)
fi

fi

if [[ -z "$NIX_QT_PIC" ]]; then
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -fPIC"
    export NIX_QT_PIC=1
fi
