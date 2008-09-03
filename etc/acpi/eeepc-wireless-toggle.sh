#!/bin/sh
######################################################################
# eeepc-wireless-toggle.sh v1.2 by Adam McDaniel, (c) 2008
#
# Script that turns wireless on or off. Loads and unloads appropriate
# modules for the Asus Eee PC model.
######################################################################

DMIDEC="/usr/sbin/dmidecode"
MODPROBE="/sbin/modprobe"

PRODUCT=`${DMIDEC} -s system-product-name`

WLAN_PROC="/proc/acpi/asus/wlan"
WLAN_STATE=`cat ${WLAN_PROC}`


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
	ifconfig ath0 down
	${MODPROBE} -r ath_pci
	echo 0 > ${WLAN_PROC}
}


enable_atheros_wireless () {
	${MODPROBE} ath_pci
	echo 1 > ${WLAN_PROC}
}


disable_ralink_wireless () {
	ifconfig ra0 down
	${MODPROBE} -v rt2860sta
	echo 0 > ${WLAN_PROC}
}


enable_ralink_wireless () {
	${MODPROBE} rt2860sta
	echo 1 > ${WLAN_PROC}
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
		if [ ${PRODUCT} -le 900 ]; then
			enable_atheros_wireless
		else
			enable_ralink_wireless
		fi
		;;
	1)
		if [ ${PRODUCT} -le 900 ]; then
			disable_atheros_wireless
		else
			disable_ralink_wireless
		fi
		;;
esac
