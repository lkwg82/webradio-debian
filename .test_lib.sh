function status {
  echo -n "INFO $1 ..."
}

function status_ok {
  echo "ok"
}

function v_ssh(){
  vagrant ssh --no-tty -c "$1" 2>/dev/null
}

function sleep_seconds() {
  local seconds=$1
  status "sleeping some ${seconds}s"
  sleep "$seconds"
  status_ok
}

function v_check_chrome_service_running() {
  status "checking chrome service running"
  exitCode=$(v_ssh 'ps aux | grep -v grep | grep -q chromium ; echo $?')
  if [[ ${exitCode} == "1" ]]; then
    echo "ERROR chromium service not running"
    exit "${exitCode}"
  fi
  status_ok
}

function v_check_spotify_service_running() {
  status "checking spotify service running"
  exitCode=$(v_ssh 'ps aux | grep -v grep | grep -q librespot-api ; echo $?')
  if [[ ${exitCode} == "1" ]]; then
    echo "ERROR spotify service not running"
    exit "${exitCode}"
  fi
  status_ok
}

function v_do_reboot() {
  set +e
  v_ssh 'sudo reboot '
  set -e
}
function v_do_poweroff() {
  set +e
  v_ssh 'sudo poweroff'
  set -e
}

function v_upload_install() {
  local package=$1
  status "installing package '$package'"
  echo
  vagrant upload "$package" | sed -e 's#^#\t#g'
  v_ssh "sudo dpkg -i $package || sudo apt-get install -f -y" | sed -e 's#^#\t#g'
  v_ssh "sudo dpkg -i $package" | sed -e 's#^#\t#g'
}
