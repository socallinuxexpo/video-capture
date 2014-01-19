#!/bin/bash

# stream h264 from /dev/video0 to hostip 

gst-launch-1.0 -v v4l2src device=/dev/video0 norm=45056 ! omxh264enc !  rtph264pay pt=96 ! udpsink host=${1} port=5000

