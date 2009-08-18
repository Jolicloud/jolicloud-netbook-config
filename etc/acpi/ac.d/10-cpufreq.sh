#!/bin/sh

. /usr/share/acpi-support/power-funcs

getState

if [ $STATE = "AC" ]; then
    for i in `find /sys/devices/system/cpu -name scaling_governor`; do
        echo "performance" > $i;
    done
fi
