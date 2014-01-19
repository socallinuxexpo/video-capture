#!/bin/bash

#this pipeline recotds /dev/video0 to test.ts

gst-launch-1.0 -v v4l2src device=/dev/video0 norm=45056 ! queue ! videoconvert ! omxh264enc ! video/x-h264,width=720,height=480 ! mpegtsmux ! filesink location=test.ts
