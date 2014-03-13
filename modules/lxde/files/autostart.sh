#!/bin/bash
setxkbmap -model pc105 -layout de
xhost +
/usr/bin/x11vnc -safer -nopw -forever &


