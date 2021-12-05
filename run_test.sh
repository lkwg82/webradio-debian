#!/bin/bash

set -euo pipefail

# build build image
docker build -t build -f Docker_build .
docker run --rm -i -v "$PWD:/out" -w /out --user "$(id -u)" \
    build \
    dpkg-deb --build /src webradio.deb

# test images
docker build -t test_debian_10 -f Docker_debian_10 .

function run_debian_10 {
  docker run --rm -i -v "$PWD:/tmp" -w /tmp \
      test_debian_10 \
      "$@"
}

run_debian_10 dpkg -i webradio.deb

dpkg -c webradio*deb

function check_file_in_deb {
  local pattern=$1
  echo -n "check ... $pattern "
  if dpkg -c webradio*deb | grep "$pattern"; then
    echo "ok"
  else
    echo "fail"
    exit 1
  fi
}

check_file_in_deb opt/librespot/librespot-api.jar

if [[ -n ${CI:-} ]]; then
  echo "skipping interactive part"
  exit
fi

. .test_lib.sh

vagrant up
v_upload_install webradio.deb

v_check_spotify_service_running
v_check_chrome_service_running

v_do_reboot
sleep_seconds 30

v_check_spotify_service_running
v_check_chrome_service_running

v_do_poweroff

