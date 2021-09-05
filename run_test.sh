#!/bin/bash

set -euo pipefail
shopt -s expand_aliases

# build build image
docker build -t build -f Docker_build .
docker run --rm -ti -v "$PWD:/out" -w /out --user "$(id -u)" \
    build \
    dpkg-deb --build /src webradio.deb

# test images
docker build -t test_debian_10 -f Docker_debian_10 .

function run_debian_10 {
  docker run --rm -ti -v "$PWD:/tmp" -w /tmp \
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

if [[ -n ${CI} ]]; then
  echo "skipping interactive part"
  exit
fi

vagrant_environment=${VAGRANT_ENVIRONMENT:-withgui}

vagrant up "${vagrant_environment}"
vagrant upload webradio.deb "${vagrant_environment}"
vagrant ssh "${vagrant_environment}" -- 'sudo dpkg -i webradio.deb || sudo apt-get install -f -y'
vagrant ssh "${vagrant_environment}" -- 'sudo dpkg -i webradio.deb'
vagrant ssh "${vagrant_environment}" -- 'sudo shutdown -r now'