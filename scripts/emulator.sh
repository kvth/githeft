#!/usr/bin/env bash
#
# Runs Githeft in an Android emulator inside podman. Needs /dev/kvm. The
# image is the `emulator` stage of the Containerfile; set EMULATOR_IMAGE to
# use another image with an AVD called "test" (e.g. one from another project).
#
# Usage: scripts/emulator.sh <command>
#   start                  boot the emulator and install the APK
#   install                reinstall build/outputs/githeft-release.apk (or $APK), keeping app data
#   app                    open Githeft
#   view                   open a window showing the emulator to click and type in
#   texts                  list the text on screen with the position to tap it
#   tap <x> <y>            tap at screen pixels (the screen is 1080x2400)
#   type <text>            type text into the focused field
#   key <keycode>          press a key, e.g. KEYCODE_BACK
#   screenshot [file.png]  save a screenshot (default build/emulator/screenshot.png)
#   logcat                 the app's log lines and crashes
#   corelog                the Go core's log (githeft.log in the app's files)
#   remote                 run scripts/testremote next to the emulator: a git host with
#                          http://10.0.2.2:8418/notes.git (user test, password secret) and
#                          ssh://git@10.0.2.2:2222/notes.git (any key)
#   adb <args...>          run any adb command in the emulator
#   stop                   shut the emulator down

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

CONTAINER=githeft-emulator
VIEWER=githeft-emulator-view
REMOTE=githeft-testremote
IMAGE=${EMULATOR_IMAGE:-localhost/githeft-emulator}
PACKAGE=io.github.kvth.githeft
APK=${APK:-build/outputs/githeft-release.apk}
OUT=build/emulator

die() { echo "error: $*" >&2; exit 1; }

adb() { podman exec "$CONTAINER" adb "$@"; }

require_running() {
  [ "$(podman inspect -f '{{.State.Running}}' "$CONTAINER" 2>/dev/null)" = true ] ||
    die "the emulator isn't running; start it with: $0 start"
}

wait_for_boot() {
  for _ in $(seq 1 150); do
    [ "$(adb shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')" = 1 ] && return
    sleep 2
  done
  die "the emulator did not finish booting"
}

cmd_install() {
  require_running
  [ -f "$APK" ] || die "no APK at $APK; build it with scripts/build.sh apk"
  podman cp "$APK" "$CONTAINER:/tmp/githeft.apk"
  adb install -r /tmp/githeft.apk | tail -1
}

cmd_start() {
  [ -r /dev/kvm ] && [ -w /dev/kvm ] || die "/dev/kvm is not accessible"
  if ! podman image exists "$IMAGE"; then
    echo "==> Building the emulator image (cached after the first run)"
    podman build --ulimit nofile=65536:65536 -f Containerfile --target emulator -t "$IMAGE" .
  fi
  echo "==> Booting Android"
  podman rm -f "$VIEWER" "$CONTAINER" >/dev/null 2>&1 || true
  # The AVD runs from a tmpfs: its data is thrown away anyway, and the
  # emulator insists on several GB of free disk otherwise.
  podman run -d --name "$CONTAINER" --device /dev/kvm --tmpfs /avd:rw,size=8g "$IMAGE" bash -c '
    cp -a /root/.android/avd/. /avd/
    sed -i "s|/root/.android/avd|/avd|" /avd/test.ini
    ANDROID_AVD_HOME=/avd exec emulator -avd test -no-window -no-audio -no-boot-anim -no-metrics \
      -gpu swiftshader_indirect -no-snapshot -memory 3072 -partition-size 2048' >/dev/null
  wait_for_boot
  # Gesture navigation leaves more of the screen to the app.
  adb shell cmd overlay enable com.android.internal.systemui.navbar.gestural >/dev/null 2>&1 || true
  echo "==> Installing Githeft"
  cmd_install
  cmd_app
  echo "==> Ready. Watch and click along with: $0 view"
}

cmd_app() {
  require_running
  adb shell monkey -p "$PACKAGE" -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1
}

cmd_view() {
  require_running
  [ -n "${DISPLAY:-}" ] || die "no X display (DISPLAY is not set)"
  local xauth=()
  [ -n "${XAUTHORITY:-}" ] && xauth=(-v "$XAUTHORITY:/tmp/.Xauthority:ro" -e XAUTHORITY=/tmp/.Xauthority)
  podman rm -f "$VIEWER" >/dev/null 2>&1 || true
  podman run -d --name "$VIEWER" --network "container:$CONTAINER" \
    -e DISPLAY="$DISPLAY" -v /tmp/.X11-unix:/tmp/.X11-unix "${xauth[@]}" \
    -e ADB=/opt/android-sdk/platform-tools/adb \
    "$IMAGE" scrcpy --render-driver=software --no-audio --window-title "Githeft emulator" >/dev/null
  echo "==> Opened the emulator window (back: right click, home: middle click)"
}

cmd_remote() {
  require_running
  mkdir -p build
  CGO_ENABLED=0 go build -o build/testremote ./scripts/testremote
  podman rm -f "$REMOTE" >/dev/null 2>&1 || true
  # Shares the emulator container's network: the emulator's 10.0.2.2 is
  # that network's localhost.
  podman run -d --name "$REMOTE" --network "container:$CONTAINER" \
    -v "$REPO_ROOT/build/testremote:/usr/local/bin/testremote:ro,Z" \
    localhost/githeft-toolchain testremote -seed >/dev/null
  sleep 2
  podman logs "$REMOTE"
}

cmd_texts() {
  require_running
  adb shell uiautomator dump /data/local/tmp/ui.xml >/dev/null
  adb shell cat /data/local/tmp/ui.xml | python3 -c '
import re, sys
import xml.etree.ElementTree as ET
for node in ET.fromstring(sys.stdin.read()).iter("node"):
    text = node.get("text") or node.get("content-desc")
    if not text and node.get("clickable") != "true":
        continue
    x1, y1, x2, y2 = map(int, re.findall(r"\d+", node.get("bounds")))
    kind = node.get("class").split(".")[-1]
    print(f"{(x1 + x2) // 2:5} {(y1 + y2) // 2:5}  {kind:<12} {text!r}")
'
}

cmd_screenshot() {
  require_running
  local file="${1:-$OUT/screenshot.png}"
  mkdir -p "$(dirname "$file")"
  adb exec-out screencap -p > "$file"
  echo "$file"
}

command="${1:-}"
[ $# -gt 0 ] && shift
case "$command" in
  start) cmd_start ;;
  install) cmd_install ;;
  app) cmd_app ;;
  view) cmd_view ;;
  texts) cmd_texts ;;
  tap) require_running; adb shell input tap "${1:?x}" "${2:?y}" ;;
  type)
    require_running
    # Single quotes keep the device shell from reading # and friends; spaces
    # are %s to input text.
    text=$(printf %s "${1:?text}" | sed "s/'/'\\\\''/g; s/ /%s/g")
    adb shell "input text '$text'" ;;
  key) require_running; adb shell input keyevent "${1:?keycode}" ;;
  screenshot) cmd_screenshot "$@" ;;
  logcat) require_running; adb logcat -d -s flutter:V AndroidRuntime:E DEBUG:V ;;
  remote) cmd_remote ;;
  corelog) require_running; adb shell run-as "$PACKAGE" cat files/githeft.log ;;
  adb) require_running; adb "$@" ;;
  stop) podman rm -f "$VIEWER" "$REMOTE" "$CONTAINER" >/dev/null 2>&1 || true; echo "stopped" ;;
  *) awk 'NR > 2 && /^#/ { sub(/^# ?/, ""); print; next } NR > 2 { exit }' "$0"; exit 1 ;;
esac
