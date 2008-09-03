#!/bin/sh

wlan_control=/proc/acpi/asus/wlan

WLANSTATE=$(cat $wlan_control)

case $WLANSTATE in
	0)
		modprobe ath_pci
		echo 1 > $wlan_control
		;;
	1)
		ifconfig ath0 down
		modprobe -r ath_pci
		echo 0 > $wlan_control
		;;
esac
