#!/bin/bash
setxkbmap -model pc105 -layout de
xhost +
/usr/bin/xrandr -s 1024x768
/usr/bin/x11vnc -safer -nopw -forever &


