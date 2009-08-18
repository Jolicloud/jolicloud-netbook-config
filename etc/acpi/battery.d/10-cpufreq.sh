#!/bin/sh

. /usr/share/acpi-support/power-funcs

getState

if [ $STATE = "BATTERY" ]; then
    for i in `find /sys/devices/system/cpu -name scaling_governor`; do
        echo "ondemand" > $i;
    done
fi
