#!/bin/bash
#
# Webcam toggle script --  EeePC 901/1000
# v1.2
# by elmurato

cam_control=/proc/acpi/asus/camera
CAMSTATE=$(cat $cam_control)

cam_on(){
    modprobe uvcvideo
    sleep 1
    echo 1 > $cam_control
}

cam_off(){

    modprobe -r uvcvideo    
    sleep 1
    echo 0 > $cam_control
}

case $CAMSTATE in
    0)
	/etc/acpi/eeepc-cam-notify.py on
	cam_on
	;;
    1)
	/etc/acpi/eeepc-cam-notify.py off
	cam_off
	;;
esac

