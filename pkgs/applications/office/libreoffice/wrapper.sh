#!@bash@/bin/bash
export JAVA_HOME="${JAVA_HOME:-@jdk@}"
#export SAL_USE_VCLPLUGIN="${SAL_USE_VCLPLUGIN:-gen}"

if uname | grep Linux > /dev/null && 
       ! ( test -n "$DBUS_SESSION_BUS_ADDRESS" ); then
    dbus_tmp_dir="/run/user/$(id -u)/libreoffice-dbus"
    mkdir "$dbus_tmp_dir"
    dbus_socket_dir="$(mktemp -d -p "$dbus_tmp_dir")"
    "@dbus@"/bin/dbus-daemon --nopidfile --nofork --config-file "@dbus@"/share/dbus-1/session.conf --address "unix:path=$dbus_socket_dir/session"  &> /dev/null &
    export DBUS_SESSION_BUS_ADDRESS="unix:path=$dbus_socket_dir/session"
fi

"@libreoffice@/bin/$(basename "$0")" "$@"
code="$?"

test -n "$dbus_socket_dir" && rm -rf "$dbus_socket_dir"
exit "$code"
