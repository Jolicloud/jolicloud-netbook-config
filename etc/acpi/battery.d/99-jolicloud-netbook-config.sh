#!/bin/sh

. /usr/share/acpi-support/power-funcs

getState

if [ $STATE = "BATTERY" ]; then
    for i in `find /sys/devices/system/cpu -name scaling_governor`; do
        echo "ondemand" > $i;
    done

    if [ -e /sys/devices/system/cpu/sched_smt_power_savings ]; then
        echo 1 > /sys/devices/system/cpu/sched_smt_power_savings;
    fi
fi
