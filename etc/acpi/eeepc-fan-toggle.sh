#!/bin/bash
#
# Fan control script --  EeePC 901/1000
# v1.2
# by elmurato
# NOTE: The modules i2c-i801 and eee must be loaded to control the fan. 

fan_mode=/proc/eee/fan_manual
fan_speed=/proc/eee/fan_speed
FANSTATE=$(cat $fan_mode)

#Turn off automatic fan control - Fan speed is always 27%
manual_mode(){
    echo 1 > $fan_mode
    echo 27 > $fan_speed
}

#Turn on automatic fan control
auto_mode(){
    echo 0 > $fan_mode
}

case $FANSTATE in
    0)
	/etc/acpi/eeepc-fan-notify.py manual
	manual_mode
	;;
    1)
	/etc/acpi/eeepc-fan-notify.py auto
	auto_mode
	;;
esac

