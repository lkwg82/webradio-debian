#!/bin/bash

set -e

sed -i 's/"exited_cleanly": false/"exited_cleanly": true/' ~/.config/chromium/Default/Preferences

chromium \
  --noerrdialogs \
  --disable-features=PreloadMediaEngagementData,AutoplayIgnoreWebAudio,MediaEngagementBypassAutoplayPolicies \
  --autoplay-policy=no-user-gesture-required \
  --disable-infobars  \
  --check-for-update-interval=9604800 \
  --disable-pinch \
  --kiosk \
  --app=https://lkwg82.github.io/webradio/