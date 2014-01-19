#!/bin/bash

#this pipeline will play port 5000 from pi

gst-launch-1.0 -v udpsrc port=5000 ! "application/x-rtp,media=video,clock-rate=90000,encoding-name=H264,payload=96" ! rtpjitterbuffer ! rtph264depay ! queue ! decodebin ! videoconvert ! videoscale ! autovideosink

