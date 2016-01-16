#!/usr/bin/python3

import dbus

import sys

def print_usage():
    print('error, wrong usage')
    print('Usage: ' + sys.argv[0] + 'playpause/next/previous')

#parse args
if len(sys.argv) != 2:
    print_usage()
else:#setup dbus
    dbusBusName = 'org.mpris.MediaPlayer2.rhythmbox'
    dbusObject = '/org/mpris/MediaPlayer2'
    bus = dbus.SessionBus()
    proxy = bus.get_object(dbusBusName, dbusObject)
    playerInterface = dbus.Interface(proxy, 'org.mpris.MediaPlayer2.Player')
    propertiesManager = dbus.Interface(proxy, 'org.freedesktop.DBus.Properties')

    if str(sys.argv[1]) == 'playpause':
        playerInterface.PlayPause()
    elif str(sys.argv[1]) == 'next':
        playerInterface.Next()
    elif str(sys.argv[1]) == 'previous':
        playerInterface.Previous()
    else:
        print_usage()
