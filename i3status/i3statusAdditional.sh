#!/bin/bash

# shell script to prepend i3status with more stuff

i3status --config ~/.config/i3status/config | while :
do
    read line
    LG=$(setxkbmap -query | awk '/layout/{print $2}')
    externalIp=$(dig +short myip.opendns.com @resolver1.opendns.com)
        if [ $LG == "de" ]
        then
            dat="[{ \"full_text\": \"layout: $LG\", \"color\":\"#00FF00\" },"
        else
            dat="[{ \"full_text\": \"layout: $LG\", \"color\":\"#FF0000\" },"
        fi
    dat+="{ \"full_text\": \"ext. IP: $externalIp\"},"
    echo "${line/[/$dat}" || exit 1
done
