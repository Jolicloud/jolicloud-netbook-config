#!/bin/bash
#
# LVDS toggle script -- EeePC 901/1000
# v1.2
# by elmurato
# Based on a script from wiki.eeeuser.com

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

checkLVDSStatus()
{
    status=`xrandr -q`
    if [ $(echo $status | grep -q "LVDS connected (" ; echo $?) -eq 0 ]
    then
        return 0
    else
        return 1
    fi
}

for x in /tmp/.X11-unix/*; do
   displaynum=`echo $x | sed s#/tmp/.X11-unix/X##`
   getXuser;
   if [ x"$XAUTHORITY" != x"" ]; then
       export DISPLAY=":$displaynum"
       checkLVDSStatus;
       case $? in
	   0 ) xrandr --output LVDS --mode 1024x600;; # LCD on
           1 ) xrandr --output LVDS --off;; # LCD off
       esac
   fi
done

