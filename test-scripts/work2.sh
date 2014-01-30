#!/bin/bash
#first pass a a pipeline to push from SNP-6200 rtsp to gst-switch.

#this test pipe line should provide data from snp-6200 to gst-switch
ipaddress=192.168.2.155

gst-launch-1.0 -v rtspsrc location=rtspt://${ipaddress}:554/profile3/media.smp latency=0 name=camera camera. ! rtpjitterbuffer ! rtph264depay ! video/x-h264,height=1080,width=1980 ! vaapidecode ! tee name=rawvideo  camera. ! rtpjitterbuffer ! rtpg726depay ! avdec_g726 ! tee name=rawaudio ! queue ! alsasink sync=false \
  videomixer name=mixer sink_1::xpos=480 sink_1::ypos=60 ! videoconvert ! "video/x-raw, width=1920, height=1080"! vaapisink \
  videotestsrc pattern=smpte ! video/x-raw,width=1440,height=960 ! mixer. \
  multifilesrc location="lax.jpg" caps="image/jpeg,framerate=1/1" ! \
     jpegdec  ! "video/x-raw, width=1920, height=1080" ! mixer.
