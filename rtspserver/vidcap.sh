#!/bin/bash


gst-launch-1.0 -v v4l2src device=/dev/video0 ! \
	"video/x-raw,format=I420,framerate=30000/1001,width=720,height=480,interlace-mode=mixed,pixel-aspect-ratio=1/1" ! \
  deinterlace mode=1 method=6 fields=1 ! \
	"video/x-raw,format=I420,framerate=30000/1001,width=720,height=480,interlace-mode=progressive,pixel-aspect-ratio=1/1" ! \
  videorate ! \
	"video/x-raw,format=I420,framerate=30/1,width=720,height=480,interlace-mode=progressive,pixel-aspect-ratio=1/1" ! \
  avenc_mpeg2video bitrate=1000000 ! mpegtsmux ! filesink location=test.ts
