#!/bin/bash

export DISPLAY=:1
xset dpms 0 0 0
xset -dpms
xset s off
xset s noblank
#xset s 0 0 s off s noblank
unclutter -idle 0.01 -root &
chromium-browser --incognito --kiosk http://signs.socallinuxexpo.org/
