#!/bin/bash

find /schatzkammer/kamera/video -type f -mtime +5 -exec rm -r {} \;
