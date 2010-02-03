#!/bin/bash

if `lspci | grep VIA | grep -q "Chrome 9\|UniChrome"`; then

    # Configure X11.org with VIA-specific configuration

    if [ -e /usr/lib/jolicloud-netbook-config/config-xorg-via.py ]; then
        /usr/lib/jolicloud-netbook-config/config-xorg-via.py
    fi


    # Disable smooth-scrolling in the firefox and prism javascript config files
    for f in `find /etc -name "jolicloud-*.js"`; do
        if [ `grep "general.smoothScroll" $f | grep -c "true"` -ne 0 ]; then
            sed -i "s/general.smoothScroll\", true/general.smoothScroll\", false/" $f
        fi
    done
fi
