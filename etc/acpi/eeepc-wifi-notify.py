#!/usr/bin/env python
#
# Wifi toggle notification -- EeePC 901/1000
# v1.2
# by elmurato
# Modified version from NiceeePC (https://launchpad.net/niceeepc)

import pygtk
pygtk.require('2.0')
import pynotify
import sys
import gtk
import os

if __name__ == '__main__':
	if not pynotify.init("Wifi Status"):
                print "Unable to initialize Python Notify"
		sys.exit(1)

	if len(sys.argv) != 2:
		print "USAGE: " + sys.argv[0] + " (on|off)"
		sys.exit(1)

	uri = "file:///usr/share/icons/gnome/scalable/devices/network-wireless.svg"

	if sys.argv[1] == "off":
		n = pynotify.Notification("WLAN", "Your wireless adapter is being <b><span color='red'>disabled</span></b>. ", uri)
	elif sys.argv[1] == "on":
		n = pynotify.Notification("WLAN", "Your wireless adapter is being <b><span color='green'>enabled</span></b>. ", uri)
	elif sys.argv[1] == "retry":
		n = pynotify.Notification("WLAN", "Please wait. Your wireless adapter is being <b><span color='orange'>restarted</span></b>. ", uri)
	elif sys.argv[1] == "fail":
		n = pynotify.Notification("WLAN", "Your wireless adapter has <b><span color='red'>failed</span></b> to return. Please reboot. ", uri)
	else:
		print "USAGE: " + sys.argv[0] + " (on|off|retry)"
		sys.exit(1)
		
	n.set_timeout(3000)
	if not n.show():
		print "Failed to send notification"
		sys.exit(1)

