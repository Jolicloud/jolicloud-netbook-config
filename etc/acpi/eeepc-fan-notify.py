#!/usr/bin/env python
#
# Fan control notification -- EeePC 901/1000
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
	if not pynotify.init("Fan Status"):
                print "Unable to initialize Python Notify"
		sys.exit(1)

	if len(sys.argv) != 2:
		print "USAGE: " + sys.argv[0] + " (auto|manual)"
		sys.exit(1)

	uri = "file:///usr/share/icons/gnome/scalable/categories/gnome-settings.svg"

	if sys.argv[1] == "manual":
		n = pynotify.Notification("Fan control", "Your automatic fan control has been <b><span color='red'>disabled</span></b>. Fan speed set to 27%.", uri)
	elif sys.argv[1] == "auto":
		n = pynotify.Notification("Fan control", "Your automatic fan control has been <b><span color='green'>enabled</span></b>. ", uri)
	else:
		print "USAGE: " + sys.argv[0] + " (auto|manual)"
		sys.exit(1)
		
	n.set_timeout(3000)
	if not n.show():
		print "Failed to send notification"
		sys.exit(1)

