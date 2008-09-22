#!/bin/sh
######################################################################
# eeepc-wireless-toggle.sh v1.2 by Adam McDaniel, (c) 2008
#
# Script that turns wireless on or off. Loads and unloads appropriate
# modules for the Asus Eee PC model.
######################################################################

MODPROBE="/sbin/modprobe"

WLAN_PROC="/proc/acpi/asus/wlan"
WLAN_STATE=`cat ${WLAN_PROC}`


# Load shared functions

. /usr/lib/eeepc-config/functions


# Load defaults

if [ -e /etc/default/eeepc-config ]; then
    . /etc/default/eeepc-config
fi


######################################################################
#
# functions
#
######################################################################

disable_atheros_wireless () {
	if isKernelLaterThan "2.6.27"; then
		ifconfig wlan0 down
		${MODPROBE} -r ath5k
	else
		ifconfig ath0 down
		${MODPROBE} -r ath_pci
	fi
	${MODPROBE} -r pciehp
	sleep 1

	echo 0 > ${WLAN_PROC}

	return 0
}


enable_atheros_wireless () {
	${MODPROBE} pciehp pciehp_force=1
	if isKernelLaterThan "2.6.27"; then
		${MODPROBE} ath5k
	else
		${MODPROBE} ath_pci
	fi
	sleep 1

	echo 1 > ${WLAN_PROC}
	sleep 1

	# validate that it came back up
	if isKernelLaterThan "2.6.27"; then
		/sbin/ifconfig wlan0 > /dev/null 2> /dev/null
	else
		/sbin/ifconfig ath0 > /dev/null 2> /dev/null
	fi

	return $?
}


disable_ralink_wireless () {
	ifconfig ra0 down
	${MODPROBE} -r rt2860sta
	${MODPROBE} -r pciehp
	sleep 1

	echo 0 > ${WLAN_PROC}

	return 0
}


enable_ralink_wireless () {
	${MODPROBE} pciehp pciehp_force=1
	${MODPROBE} rt2860sta
	sleep 1

	echo 1 > ${WLAN_PROC}
	sleep 1

	# validate that it came back up
	/sbin/ifconfig ra0 > /dev/null 2> /dev/null

	return $?
}


######################################################################
#
# main
#
######################################################################

# sanity check

# If /proc/acpi/asus/wlan doesn't exist, something's wrong. Stop.

if [ ! -e ${WLAN_PROC} ]; then
	exit 0
fi

case ${WLAN_STATE} in
	0)
		/etc/acpi/eeepc-wifi-notify.py on
		if isModelLessThanOrEqualTo "900a"; then
			enable_atheros_wireless
		else
			enable_ralink_wireless
		fi
		if [ $? -ne 0 ]; then
			/etc/acpi/eeepc-wifi-notify.py fail
		fi
		;;
	1)
		/etc/acpi/eeepc-wifi-notify.py off
		echo "bar?"
		if isModelLessThanOrEqualTo "900a"; then
			disable_atheros_wireless
		else
			disable_ralink_wireless
		fi
		;;
esac

# vim:noexpandtab
