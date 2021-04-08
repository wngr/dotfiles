#!/bin/bash

# record 15 min
ffmpeg -rtsp_transport tcp -i "rtsp://admin:@192.168.178.171/videoMain" \
-an \
-strftime 1 \
-vcodec copy \
-t 900 \
`dirname $0`/video/`date +%Y-%m-%d_%H-%M-%S`.mp4

#-filter:v fps=fps=5 \
#ffmpeg -rtsp_transport tcp -i "rtsp://admin:@192.168.178.171/videoMain" \
#	-f segment \
#	-segment_time 120 \
#	-segment_format mp4 \
#	-reset_timestamps 1 \
#	-an \
#	-strftime 1 \
#	-filter:v fps=fps=5 \
#	"%Y-%m-%d_%H-%M-%S.mp4"
