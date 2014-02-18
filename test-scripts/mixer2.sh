#!/bin/bash

gst-launch-1.0 -v videomixer name=mix sink_1::xpos=840 sink_1::ypos=360 ! videoconvert ! "video/x-raw, width=1920, height=1080"! vaapisink \
   videotestsrc pattern=smpte ! video/x-raw,width=1080,height=720 ! mix. \
   videotestsrc pattern=smpte ! video/x-raw,width=1920,height=1080 ! \
     videoscale ! video/x-raw,width=840,height=473,framerate=30/1 ! mix. \
   multifilesrc location="lax.jpg" caps="image/jpeg,framerate=1/1" ! \
     jpegdec  ! "video/x-raw, width=1920, height=1080" ! mix.

