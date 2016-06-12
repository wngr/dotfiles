#!/bin/bash

SERVICE="disable-standby-fs.py"

if ps ax | grep -v grep | grep $SERVICE > /dev/null
then
    echo "$SERVICE running."
else
    echo "$SERVICE not running. Restarting.."
    /usr/bin/python3 ~/Projects/linux-utils/i3wm/disable-standby-fs.py
fi
