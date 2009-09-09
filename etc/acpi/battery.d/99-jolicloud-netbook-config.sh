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

    # Disable Advanced Power Management on all drives. This disables the
    # incessant clicking heard by cheap harddrives while on battery power.
    for d in `ls /dev/disk/by-id | grep scsi | grep -v "\-part"`; do
        /sbin/hdparm -B 255 /dev/disk/by-id/$d > /dev/null
    done
fi

return 0
