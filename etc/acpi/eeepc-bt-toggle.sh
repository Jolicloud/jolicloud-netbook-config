#!/bin/bash
#
# BT toggle script --  EeePC 901/1000
# v1.2
# by elmurato
# Based on the script from Merkmal (forum.eeeuser.com)

bt_control=/proc/acpi/asus/bt
BTSTATE=$(cat $bt_control)

bt_on(){
    modprobe bluetooth
    modprobe hci_usb
    sleep 1
    echo 1 > $bt_control
}

bt_off(){

    modprobe -r hci_usb
    modprobe -r bluetooth    
    sleep 1
    echo 0 > $bt_control
}

case $BTSTATE in
    0)
	/etc/acpi/eeepc-bt-notify.py on
	bt_on
	;;
    1)
	/etc/acpi/eeepc-bt-notify.py off
	bt_off
	;;
esac

