#!/bin/bash

ipaddress=192.168.2.155

gst-launch-1.0 -v videomixer name=mix sink_1::xpos=480 sink_1::ypos=60 ! \
   videoconvert ! "video/x-raw, width=1920, height=1080"! autovideosink \
   videotestsrc pattern=smpte ! video/x-raw,width=1440,height=960 ! mix. \
   rtspsrc location=rtspt://${ipaddress}:554/profile3/media.smp \
	latency=0 name=camera ! \
     rtph264depay ! video/x-h264,height=1080,width=1980 ! \
     decodebin ! queue ! videoscale ! \
 	video/x-raw,width=480,height=270,framerate=30/1 ! mix. \
     camera. ! rtpjitterbuffer ! rtpg726depay ! avdec_g726 ! queue ! \
     alsasink sync=false \
   multifilesrc location="lax.jpg" caps="image/jpeg,framerate=1/1" ! \
     jpegdec  ! "video/x-raw, width=1920, height=1080" ! mix.

#gst-launch-1.0 -v rtspsrc location=rtspt://${ipaddress}:554/profile3/media.smp latency=0 name=camera camera. ! rtpjitterbuffer ! rtph264depay ! video/x-h264,height=1080,width=1980 ! vaapidecode ! queue ! vaapisink camera. ! rtpjitterbuffer ! rtpg726depay ! avdec_g726 ! queue ! alsasink sync=false




