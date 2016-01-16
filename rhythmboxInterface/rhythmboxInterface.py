#!/usr/bin/python3
'''
Script checks if Rhythmbox is playing, if so, touches tmpFilePath to remember that and pauses Rhythmbox.
If Rhythmbox is not playing and tmpFilePath exists, removes tmpFilePath and unpauses Rhythmbox.
'''

import dbus
import pathlib
import os

dbusBusName = 'org.mpris.MediaPlayer2.rhythmbox'
dbusObject = '/org/mpris/MediaPlayer2'
tmpFilePath = '/tmp/.rhythmboxWasPlaying'

#setup dbus objects
bus = dbus.SessionBus()
proxy = bus.get_object(dbusBusName, dbusObject)
playerInterface = dbus.Interface(proxy, 'org.mpris.MediaPlayer2.Player')
propertiesManager = dbus.Interface(proxy, 'org.freedesktop.DBus.Properties')

#get current state
curStatus = propertiesManager.Get('org.mpris.MediaPlayer2.Player', 'PlaybackStatus')

tmpFile = pathlib.Path(tmpFilePath)

if tmpFile.is_file(): #rhythmbox was playing before
    if not curStatus == "Playing":
        playerInterface.PlayPause()
    os.remove(tmpFilePath)

else:
    if curStatus == "Playing":
        with open(tmpFilePath,'a'):
            os.utime(tmpFilePath, None)
        playerInterface.PlayPause()
    #else: #nothing do to