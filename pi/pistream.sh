#!/bin/bash

# this streams colorbars with static

gst-launch-1.0 -v videotestsrc ! 'video/x-raw, width=640, height=480, framerate=15/1' ! queue ! videoconvert ! omxh264enc ! rtph264pay pt=96 ! udpsink host=#{1} port=5000
