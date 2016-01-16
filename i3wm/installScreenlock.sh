#!/bin/bash

sudo cp screenlock.service /usr/lib/systemd/system/screenlock.service
sudo systemctl daemon-reload
sudo systemctl enable screenlock.service
