#!/bin/bash

set -euo pipefail
shopt -s expand_aliases

mkdir -p tmp_empty_context_dir
# build build image
docker build -t build -f Docker_build tmp_empty_context_dir
docker run --rm -ti -v "$PWD:/src" -w /src \
    build \
    dpkg-deb --build webradio_*

# test images
docker build -t test_debian_10 -f Docker_debian_10 .

function run_debian_10 {
  docker run --rm -ti -v "$PWD:/tmp" -w /tmp \
      test_debian_10 \
      "$@"
}

packages_to_install=$(grep ^Depends: webradio_*/DEBIAN/control | cut -d: -f2 | sed -e 's#(.*)##g')

run_debian_10 dpkg -i webradio_*deb
