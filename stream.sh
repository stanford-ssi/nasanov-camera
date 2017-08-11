#!/usr/bin/env bash

URL="rtmp://a.rtmp.youtube.com/live2"
KEY=""

VBR="1500k"
FPS="30"
QUAL="medium"


ffmpeg \
    -f avfoundation -s 1024x720 -i :0.0+0,0 -f 0:0 -framerate 30 \
    -f avfoundation -ac 1 -i default \
    -vcodec libx264 -pix_fmt yuv420p -preset veryfast -b:v 1500k -g 60 \
    -acodec libmp3lame -ar 44100 -threads 0 -bufsize 3000k \
    -f flv "$URL/$KEY"