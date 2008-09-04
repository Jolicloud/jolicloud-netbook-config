#!/bin/sh

if [ -S /tmp/.X11-unix/X0 ]; then
	export DISPLAY=:0
	user=$(who | sed -n '/ (:0[\.0]*)$\| :0 /{s/ .*//p;q}')
	home=$(getent passwd $user | cut -d: -f6)
	XAUTHORITY=$home/.Xauthority
	[ -f $XAUTHORITY ] && export XAUTHORITY
fi

code=$3

. /usr/share/hotkey-setup/key-constants
. /etc/default/eeepc-config


case $code in
	# Fn+F2 -- enable/disable wifi
	0000001[01])
		${EEEPC_HOTKEY_WIRELESS_TOGGLE}
		;;
	# Fn+F5 -- VGA toggle
	0000003[012])
		${EEEPC_HOTKEY_VGA_TOGGLE}
		;;
	# Fn+F6 -- Taskmanager
	00000012)
		${EEEPC_HOTKEY_TASK_MANAGER}
		;;
	# Fn+F7 -- mute/unmute speakers
	00000013)
		${EEEPC_HOTKEY_MUTE_TOGGLE}
		;;
	# Fn+F8 -- decrease volume
	00000014)
		${EEEPC_HOTKEY_VOLUME_DOWN}
		;;
	# Fn+F9 -- increase volume
	00000015)
		${EEEPC_HOTKEY_VOLUME_UP}
		;;
#	# Fn+F7(1000) -- Internal screen toggle
#	00000016)
#		${EEEPC_HOTKEY_VGA_TOGGLE}
#		;;
	# Top row, first hotkey (>=901)
	0000001a)
		${EEEPC_HOTKEY_TOPROW1}
		;;
	# Top row, second hotkey (>=901)
	0000001b)
		${EEEPC_HOTKEY_TOPROW2}
		;;
	# Top row, third hotkey (>=901)
	0000001c)
		${EEEPC_HOTKEY_TOPROW3}
		;;
	# Top row, fourth hotkey (>=901)
	0000001d)
		${EEEPC_HOTKEY_TOPROW4}
		;;
esac
