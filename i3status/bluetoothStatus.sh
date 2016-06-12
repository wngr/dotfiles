#!/bin/bash

BLUETOOTH='Off'

rfkill list bluetooth | grep yes
if [[ $? -eq 0 ]]; then
    BLUETOOTH='Off'
else
   BLUETOOTH='On' 
fi


echo $BLUETOOTH
