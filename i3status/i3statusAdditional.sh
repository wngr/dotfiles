#!/bin/bash

# shell script to prepend i3status with more stuff

i3status --config ~/.config/i3status/config | while :
do
    read line
    LG=$(setxkbmap -query | awk '/layout/{print $2}')
        if [ $LG == "de" ]
        then
            dat="[{ \"full_text\": \"layout: $LG\", \"color\":\"#009E00\" },"
        else
            dat="[{ \"full_text\": \"layout: $LG\", \"color\":\"#C60101\" },"
        fi
    echo "${line/[/$dat}" || exit 1
done
