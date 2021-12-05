#!/bin/bash

set -ex

if [ -f ~/.config/chromium/Default/Preferences ]; then
  sed -i 's/"exited_cleanly": false/"exited_cleanly": true/' ~/.config/chromium/Default/Preferences
fi

# see https://sylvaindurand.org/launch-chromium-in-kiosk-mode/
# see https://github.com/Salamek/chromium-kiosk/blob/master/etc/systemd/system/getty%40tty1.service.d/override.conf

chromium \
  --noerrdialogs `# no errors` \
  \
  `# enable autoplay without any user interaction` \
  --disable-features=PreloadMediaEngagementData,AutoplayIgnoreWebAudio,MediaEngagementBypassAutoplayPolicies \
  --autoplay-policy=no-user-gesture-required \
  \
  --check-for-update-interval=9604800 `# no update checks` \
  --disable-pinch `# disable touch events ` \
  --start-fullscreen \
  `# see https://github.com/crosswalk-project/chromium-crosswalk/commit/a1f8d834ce9fc89e5e409e08bb00173c37854329`\
  --enable-aggressive-domstorage-flushing \
  --app=https://lkwg82.github.io/webradio/ `# single page ` \
  --kiosk \
  --remote-debugging-port=9222
#  --window-size=520,180 \
