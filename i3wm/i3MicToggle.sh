#!/bin/bash
#bindsym XF86AudioMicMute exec ~/Projects/linux-utils/i3wm/i3MicToggle.sh

function setState {
for source in $(pactl list sources | grep -oE 'Name: .+' | awk '{ print $2 }'); do
   echo $source
    pactl set-source-mute $source $1
done
}

#get curr state
amixer get Capture | grep '\[off\]'
if [[ $? -eq 0 ]]; then
    setState 0
else
    setState 1
fi
