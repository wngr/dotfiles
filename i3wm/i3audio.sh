#!/bin/bash
#
# Manages audio keys on keyboard in i3 wm and launches volnoti window

## Add the following to your i3 config file:
##
## # Media, sound, audio keys
## bindsym XF86AudioRaiseVolume exec ~/.i3/i3audio.sh inc
## bindsym XF86AudioLowerVolume exec ~/.i3/i3audio.sh dec
## bindsym XF86AudioMute exec ~/.i3/i3audio.sh mute
## exec --no-startup-id volnoti


#### Set variables

AMIXER_CARD="1"
VOL_INCREMENT="3%"

################

function unmute {
    # Unmute all pulseaudio sinks
    for sink in $(pactl list sinks | grep -oE 'Name: .+' | awk '{ print $2 }'); do
        pactl set-sink-mute $sink 0
    done
}
function mute {
    # Unmute all pulseaudio sinks
    for sink in $(pactl list sinks | grep -oE 'Name: .+' | awk '{ print $2 }'); do
        pactl set-sink-mute $sink toggle
    done
}
AMIXER="amixer -q sset Master"
#"amixer --card $AMIXER_CARD -q set Master"
case "$1" in
    inc)
        $AMIXER ${VOL_INCREMENT}+
        unmute
        ;;
    dec)
        $AMIXER ${VOL_INCREMENT}-
        unmute
        ;;
    mute) 
        mute
        #pactl set-sink-mute 1 toggle 
       ;;
    *)
        echo "Usage: $0 {inc|dec|mute}"
        exit 1
esac

