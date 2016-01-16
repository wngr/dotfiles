#!/bin/bash
#runs one additional argument, e.g. -n for nofork
scrot /tmp/screen_locked.png
convert /tmp/screen_locked.png -scale 10% -scale 1000% /tmp/screen_locked2.png
i3lock $1 -i /tmp/screen_locked2.png
rm /tmp/screen_locked.png
rm /tmp/screen_locked2.png
