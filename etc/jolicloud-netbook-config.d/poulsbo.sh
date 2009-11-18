#!/bin/bash

if `lspci | grep Poulsbo | grep -q Graphics`; then

    # Configure the libdrm-poulsbo.so.2 dynamic library to be preloaded if
    # its available. If something happened to it, remove it from the
    # preload file.

    if [ -e /usr/lib/libdrm-poulsbo.so.2 ]; then
        if [ ! -e /etc/ld.so.preload ]; then
            touch /etc/ld.so.preload
        fi
        if ! `grep -q libdrm-poulsbo /etc/ld.so.preload`; then
            echo "/usr/lib/libdrm-poulsbo.so.2" >> /etc/ld.so.preload
        fi
    else
        if `grep -q libdrm-poulsbo /etc/ld.so.preload`; then
            sed -i "s;/usr/lib/libdrm-poulsbo.so.2;;" /etc/ld.so.preload
        fi
    fi


    # Configure X11.org with poulsbo-specific configuration

    if [ -e /usr/lib/jolicloud-netbook-config/config-xorg-poulsbo.py ]; then
        /usr/lib/jolicloud-netbook-config/config-xorg-poulsbo.py
    fi
fi
