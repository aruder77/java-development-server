#!/bin/bash
nohup /usr/bin/avconv -y -f x11grab -r 25 -s xga -i :0+0,0 -vcodec libx264 -pre lossless_ultrafast -threads 0 /tmp/smokeTestVideo.mkv > /tmp/avconv.log 2>&1 &
