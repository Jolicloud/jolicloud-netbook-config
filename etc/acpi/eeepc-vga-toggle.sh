#!/bin/bash
#
# VGA toggle script -- EeePC 901/1000
# v1.2
# by elmurato
# Based on a script from wiki.eeeuser.com

enabled=-1

getXuser() {
       user=`finger| grep -m1 ":$displaynum " | awk '{print $1}'`
       if [ x"$user" = x"" ]; then
               user=`finger| grep -m1 ":$displaynum" | awk '{print $1}'`
       fi
       if [ x"$user" != x"" ]; then
               userhome=`getent passwd $user | cut -d: -f6`
               export XAUTHORITY=$userhome/.Xauthority
       else
               export XAUTHORITY=""
       fi
}
# end of getXuser from /usr/share/acpi-support/power-funcs
#

checkVGAStatus()
{
    status=`xrandr -q`

    if [ $(echo $status | grep -q "VGA connected (" ; echo $?) -eq 0 ]
    then
	enabled=0
    else
        if [ $(echo $status | grep -q "VGA connected" ; echo $?) -eq 0 ]
        then
            enabled=1
        fi
    fi
}

for x in /tmp/.X11-unix/*; do
   displaynum=`echo $x | sed s#/tmp/.X11-unix/X##`
   getXuser;
   if [ x"$XAUTHORITY" != x"" ]; then
       export DISPLAY=":$displaynum"
       checkVGAStatus;

       case $enabled in
	   0) 
		/etc/acpi/eeepc-vga-notify.py on
		xrandr --output VGA --auto # VGA on				
		;; 
	   1) 		
		xrandr --output VGA --off # VGA off
		/etc/acpi/eeepc-vga-notify.py off
		;;  
       esac
   fi
done
