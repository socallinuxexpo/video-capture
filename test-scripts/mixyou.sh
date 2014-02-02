#!/bin/bash

ident="southern-califo-0973.4pa8-30y7-md82-6jq2"

gst-launch-1.0 -v videomixer name=mix sink_1::xpos=480 sink_1::ypos=60 ! videoconvert ! "video/x-raw, width=1920, height=1080" ! \
   queue ! videoconvert ! videoscale ! "video/x-raw, width=640, height=360" ! x264enc bitrate=768 key-int-max=60 bframes=0 \
     byte-stream=false aud=true tune=zerolatency ! h264parse ! \
     "video/x-h264,level=(string)4.1,profile=main" ! queue ! mux. \
   audiotestsrc is-live=true ! "audio/x-raw,format=S16LE,endianness=1234,signed=true,width=16,depth=16,rate=44100,channels=2" ! \
     queue ! voaacenc bitrate=128000 ! \
     aacparse ! "audio/mpeg,mpegversion=4,stream-format=raw" ! queue ! \
   flvmux streamable=true name=mux ! queue ! \
   rtmpsink \
     location="rtmp://a.rtmp.youtube.com/live2/x/${ident}?videoKeyframeFrequency=1&totalDatarate=896 app=live2 flashVer=\"FME/3.0%20(compatible;%20FMSc%201.0)\" swfUrl=rtmp://a.rtmp.youtube.com/live2" \
   videotestsrc pattern=smpte is-live=true ! video/x-raw,width=1440,height=960 ! mix. \
   videotestsrc pattern=smpte is-live=true ! video/x-raw,width=1920,height=1080 ! \
     videoscale ! video/x-raw,width=480,height=270,framerate=30/1 ! mix. \
   multifilesrc location="lax.jpg" caps="image/jpeg,framerate=1/1" ! \
     jpegdec  ! "video/x-raw, width=1920, height=1080" ! mix.

