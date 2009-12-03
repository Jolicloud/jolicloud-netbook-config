#!/bin/sh

. /usr/share/acpi-support/power-funcs

getState

if [ $STATE = "BATTERY" ]; then
    for i in /sys/devices/system/cpu?/cpufreq/scaling_governor; do
        echo "ondemand" > $i;
    done

    if [ -e /sys/devices/system/cpu/sched_smt_power_savings ]; then
        echo 1 > /sys/devices/system/cpu/sched_smt_power_savings;
    fi

    # Disable Advanced Power Management on all SCSI drives. This silences the
    # incessant clicking heard by cheap harddrives while on battery power.
    for d in /dev/disk/by-id/scsi*; do
        # Regexp search to avoid grep/find. We only should run hdparm on
        # files that patch the previous for loop, but do not end in
        # part[0-9]. This avoids needlessly running hdparm for every single
        # partition configured.
        if ! [[ $d =~ part.+$ ]]; then
            /sbin/hdparm -B 255 $d > /dev/null
        fi
    done
fi

return 0
