#!/usr/bin/env python
#
# CPU frequency control notification -- EeePC 901/1000
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
	if not pynotify.init("CPU frequency"):
                print "Unable to initialize Python Notify"
		sys.exit(1)

	if len(sys.argv) != 2:
		print "USAGE: " + sys.argv[0] + " (powersave|ondemand|performance)"
		sys.exit(1)

	uri = "file:///usr/share/icons/gnome/scalable/apps/gnome-monitor.svg"

	if sys.argv[1] == "powersave":
		n = pynotify.Notification("CPU frequency", "Your CPU is now running in <b><span color='green'>powersave</span></b> mode. ", uri)
	elif sys.argv[1] == "ondemand":
		n = pynotify.Notification("CPU frequency", "Your CPU is now running in <b><span color='orange'>ondemand</span></b> mode. ", uri)
	elif sys.argv[1] == "performance":
		n = pynotify.Notification("CPU frequency", "Your CPU is now running in <b><span color='red'>performance</span></b> mode. ", uri)
	else:
		print "USAGE: " + sys.argv[0] + " (powersave|ondemand|performance)"
		sys.exit(1)
		
	n.set_timeout(3000)
	if not n.show():
		print "Failed to send notification"
		sys.exit(1)

