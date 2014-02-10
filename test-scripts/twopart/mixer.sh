#!/bin/bash

capfile=test.ts

gst-launch-1.0 -v \
  videomixer name=mix sink_1::xpos=480 sink_1::ypos=60 ! \
  videoconvert ! "video/x-raw, width=1920, height=1080" ! \
  x264enc bitrate=4000 key-int-max=60 bframes=0 \
     byte-stream=false aud=true tune=zerolatency ! h264parse ! \
     "video/x-h264,level=(string)4.1,profile=main" ! queue ! \
  mpegtsmux name=muxer ! queue ! filesink location=${capfile} \
   videotestsrc pattern=smpte ! "video/x-raw,width=1440,height=960" ! queue ! mix. \
   udpsrc port=8000 caps="application/x-rtp, media=video, clock-rate=90000, encoding-name=H264" ! \
    rtph264depay ! decodebin ! "video/x-raw,width=1920,height=1080" ! \
     videoscale ! "video/x-raw,width=480,height=270,framerate=30/1" ! queue ! mix.
   #multifilesrc location="../lax.jpg" caps="image/jpeg,framerate=1/1" ! \
   #  jpegdec  ! "video/x-raw, width=1920, height=1080" ! queue ! mix.

