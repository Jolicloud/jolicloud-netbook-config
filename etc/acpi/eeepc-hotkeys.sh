#!/bin/sh

code=$3

case $code in
	# Fn+F2 -- enable/disable wifi
	0000001[01])
		/etc/acpi/eeepc-wireless-toggle.sh
		;;
	# Fn+F7 -- mute/unmute speakers
	00000013)
		acpi_fakekey 113
		;;
	# Fn+F8 -- decrease volume
	00000014)
		acpi_fakekey 114
		;;
	# Fn+F9 -- increase volume
	00000015)
		acpi_fakekey 115
		;;
esac
