#!/bin/bash

sudo mv screenlock.service /usr/lib/systemd/system/screenlock.service
sudo systemd daemon-reload
sudo systemd enable screenlock.service
