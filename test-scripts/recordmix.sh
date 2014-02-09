#!/bin/bash

capfile=test.ts
videobr=6000
slides=192.168.2.202
camera=192.168.2.155

gst-launch-1.0 -v videomixer name=mix sink_0::xpos=480 sink_0::ypos=60 ! \
   videoconvert ! "video/x-raw, width=1920, height=1080"! \
   x264enc bitrate=${videobr} key-int-max=60 bframes=0 \
     byte-stream=false aud=true tune=zerolatency ! h264parse ! \
     "video/x-h264,level=(string)4.1,profile=main" ! queue ! muxer. \
   rtspsrc location=rtspt://${slides}:554/profile3/media.smp latency=0 \
     name=slides is-live=true ! rtpmp2tdepay ! \
     tsdemux ! decodebin ! video/x-raw,width=720,height=480 ! \
     videoscale ! "video/x-raw,width=1440,height=960" ! mix. \
   videotestsrc is-live=true pattern=smpte ! video/x-raw,width=1920,height=1080 ! \
     videoscale ! video/x-raw,width=480,height=270,framerate=30/1 ! mix. \
   mpegtsmux name=muxer ! filesink location=${capfile} #\
   #camera. ! rtpg726depay ! avdec_g726 ! audioresample ! \
   #"audio/x-raw,format=S16LE,endianness=1234,signed=true,width=16,depth=16,rate=44100" ! \
    # queue ! voaacenc bitrate=128000 ! \
    # aacparse ! "audio/mpeg,mpegversion=4,stream-format=raw" ! queue ! \
    # muxer.

