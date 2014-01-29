video-capture
=============

This repository houses scripts and codes relating to video capture and streaming for SCALE.

The main value comes from the [wiki](https://github.com/scale-av/video-capture/wiki) and [issue tracking](https://github.com/scale-av/video-capture/issues).


## System Requirements
* Python 3.3 (if needed)
* GStreamer1 (See [GStreamer notes](https://github.com/scale-av/video-capture/wiki/GStreamer-notes))
* Ubuntu 12.04

## Developer note
* Install Ubuntu 12.04
* Upgrade (sudo apt-get update && sudo apt-get upgrade
* Setup gstreamer-developers PPA
    - sudo apt-get install python-software-properties
    - sudo apt-get update
    - sudo apt-get install gstreamer1.0*
    - sudo apt-get install libgstreamer-plugins-base1.0-dev
    - sudo apt-get install v4l-utils
