#!/bin/sh
######################################################################
# eeepc-wireless-toggle.sh v1.2 by Adam McDaniel, (c) 2008
#
# Script that turns wireless on or off. Loads and unloads appropriate
# modules for the Asus Eee PC model.
######################################################################

MODPROBE="/sbin/modprobe"
IFCONFIG="/sbin/ifconfig"


# Load shared functions

. /usr/lib/eeepc-config/functions


# Load defaults

if [ -e /etc/default/eeepc-config ]; then
    . /etc/default/eeepc-config
fi


# The location of our wlan device attribute differs depending the module.
# Here we validate the older module (eeepc-acpi) location, and the newer
# module (eeepc-laptop) location.

EEEPC_ACPI_DIR="/proc/acpi/asus"
EEEPC_LAPTOP_DIR="/sys/devices/platform/eeepc"
WLAN_PROC=""

[ -d "${EEEPC_ACPI_DIR}" ] && WLAN_PROC="${EEEPC_ACPI_DIR}/wlan"
[ -d "${EEEPC_LAPTOP_DIR}" ] && WLAN_PROC="${EEEPC_LAPTOP_DIR}/wlan"
if [ ! -e "${WLAN_PROC}" ]; then
	exit 1;
fi

# Do not run on 2.6.27 or later eeepc-laptop's rfkill feature will handle
# wireless switching for us.
if isKernelLaterThan "2.6.27";
	exit 0;
fi

WLAN_STATE=`cat ${WLAN_PROC}`


######################################################################
#
# functions
#
######################################################################

disable_atheros_wireless () {
	if isKernelLaterThan "2.6.27"; then
		${IFCONFIG} wlan0 down
		${MODPROBE} -r ath5k
	else
		${IFCONFIG} ath0 down
		${MODPROBE} -r ath_pci
	fi
	sleep 1

	echo 0 > ${WLAN_PROC}

	return 0
}


enable_atheros_wireless () {
	${MODPROBE} -r pciehp
	sleep 1
	${MODPROBE} pciehp pciehp_force=1
	sleep 1
	if isKernelLaterThan "2.6.27"; then
		${MODPROBE} ath5k
	else
		${MODPROBE} ath_pci
	fi
	sleep 1

	echo 1 > ${WLAN_PROC}

	# Sometimes it takes up to 10 seconds for the driver to kick back in
	sleep 10

	# validate that it came back up
	if isKernelLaterThan "2.6.27"; then
		${IFCONFIG} wlan0 > /dev/null 2> /dev/null
	else
		${IFCONFIG} ath0 > /dev/null 2> /dev/null
	fi

	return $?
}


disable_ralink_wireless () {
	${IFCONFIG} ra0 down
	${MODPROBE} -r rt2860sta
	sleep 1

	echo 0 > ${WLAN_PROC}

	return 0
}


enable_ralink_wireless () {

# Restarting pciehp on rt2860 hardware results in wierd error messages.
# Users have reported that it shouldn't be necessary.
# http://forum.eeeuser.com/viewtopic.php?pid=403637#p403637

#	${MODPROBE} -r pciehp
#	sleep 1
#	${MODPROBE} pciehp pciehp_force=1 pciehp_poll_mode=1
#	sleep 1

	${MODPROBE} rt2860sta
	sleep 1

	echo 1 > ${WLAN_PROC}
	sleep 1

	# validate that it came back up
	${IFCONFIG} ra0 > /dev/null 2> /dev/null

	return $?
}


disable_wireless () {
	if isModelLessThanOrEqualTo "900a"; then
		enable_atheros_wireless
	else
		enable_ralink_wireless
	fi
}


disable_wireless () {
	if isModelLessThanOrEqualTo "900a"; then
		disable_atheros_wireless
	else
		disable_ralink_wireless
	fi

	return $?
}



enable_wireless () {
	if isModelLessThanOrEqualTo "900a"; then
		enable_atheros_wireless
	else
		enable_ralink_wireless
	fi

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
		enable_wireless
		if [ $? -ne 0 ]; then
			/etc/acpi/eeepc-wifi-notify.py retry
			disable_wireless
			enable_wireless
		fi
		if [ $? -ne 0 ]; then
			/etc/acpi/eeepc-wifi-notify.py retry
			disable_wireless
			enable_wireless
		fi
		if [ $? -ne 0 ]; then
			disable_wireless
			/etc/acpi/eeepc-wifi-notify.py fail
		fi
		;;
	1)
		/etc/acpi/eeepc-wifi-notify.py off
		disable_wireless
		;;
esac

# vim:noexpandtab
