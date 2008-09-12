#!/bin/bash
#
# CPU frequency control script -- EeePC 901/1000
# v1.2
# by elmurato

cpu0_control=/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
cpu1_control=/sys/devices/system/cpu/cpu1/cpufreq/scaling_governor 
CPU0STATE=$(cat $cpu0_control)
CPU1STATE=$(cat $cpu1_control)

case $CPU0STATE in
    "powersave")
	echo ondemand > $cpu0_control
	echo ondemand > $cpu1_control
	/etc/acpi/eeepc-cpufreq-notify.py ondemand
 	;;
    "ondemand")
	echo performance > $cpu0_control
	echo performance > $cpu1_control
	/etc/acpi/eeepc-cpufreq-notify.py performance
	;;
    "performance")
	echo powersave > $cpu0_control
	echo powersave > $cpu1_control
	/etc/acpi/eeepc-cpufreq-notify.py powersave
	;;
    *)
	echo powersave > $cpu0_control
	echo powersave > $cpu1_control
	/etc/acpi/eeepc-cpufreq-notify.py powersave
	;;
esac

