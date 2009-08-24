#!/bin/sh

. /usr/share/acpi-support/power-funcs

getState

if [ $STATE = "AC" ]; then
    for i in `find /sys/devices/system/cpu -name scaling_governor`; do
        echo "performance" > $i;
    done

    if [ -e /sys/devices/system/cpu/sched_smt_power_savings ]; then
        echo 0 > /sys/devices/system/cpu/sched_smt_power_savings;
    fi
fi
