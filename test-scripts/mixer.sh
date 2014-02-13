#!/bin/bash

gst-launch-1.0 -v videomixer name=mix sink_1::xpos=480 sink_1::ypos=60 ! videoconvert ! "video/x-raw, width=1920, height=1080"! autovideosink \
   videotestsrc pattern=smpte is-live=true ! video/x-raw,width=1440,height=960 ! mix. \
   videotestsrc pattern=smpte is-live=true ! video/x-raw,width=1920,height=1080 ! \
     videoscale ! video/x-raw,width=480,height=270,framerate=30/1 ! mix. \
   multifilesrc location="lax.jpg" caps="image/jpeg,framerate=1/1" ! \
     jpegdec  ! "video/x-raw, width=1920, height=1080" ! mix.

