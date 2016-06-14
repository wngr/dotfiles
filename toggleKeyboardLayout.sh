#!/bin/bash

curLayout=$(setxkbmap -query | awk '/layout/{print $2}')
firstLayout="de"
secondLayout="us"

if [ $curLayout == $firstLayout ]
then
    newLayout=$secondLayout
else
    newLayout=$firstLayout
fi
echo "set layout to $newLayout"
setxkbmap $newLayout -option compose:ralt
