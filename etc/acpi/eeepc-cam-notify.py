#!/usr/bin/env python
#
# Webcam toggle notification -- EeePC 901/1000
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
	if not pynotify.init("Webcam Status"):
                print "Unable to initialize Python Notify"
		sys.exit(1)

	if len(sys.argv) != 2:
		print "USAGE: " + sys.argv[0] + " (on|off)"
		sys.exit(1)

	uri = "file:///usr/share/icons/gnome/scalable/devices/camera-web.svg"

	if sys.argv[1] == "off":
		n = pynotify.Notification("Webcam", "Your webcam has been <b><span color='red'>disabled</span></b>. ", uri)
	elif sys.argv[1] == "on":
		n = pynotify.Notification("Webcam", "Your webcam has been <b><span color='green'>enabled</span></b>. ", uri)
	else:
		print "USAGE: " + sys.argv[0] + " (on|off)"
		sys.exit(1)
		
	n.set_timeout(3000)
	if not n.show():
		print "Failed to send notification"
		sys.exit(1)

