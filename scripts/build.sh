#!/usr/bin/env bash
#
# Builds Githeft inside the toolchain container (Containerfile), so Flutter,
# the Android SDK/NDK and Go never touch the host. The checkout is mounted at
# /src; Gradle, pub and Go caches live in podman volumes between runs.
#
# Usage: scripts/build.sh <command>...
#   toolchain        build the toolchain image (cached after the first run)
#   gen              generate the Go and Dart code from proto/
#   go-android       build libgitheft.so for the Android ABIs into the app
#   go-linux         build libgitheft.so for the Linux bundle
#   apk [debug]      build the Android APK (release by default, signed with a
#                    throwaway local key) into build/outputs/
#   linux            build the Linux bundle into build/outputs/githeft-linux/
#   web              build the web app into app/build/web (serve it with
#                    `githeft serve -web app/build/web`)
#   cli              build the githeft command into build/outputs/
#   analyze          flutter analyze + dart format check
#   format           dart format the app's code
#   test             go test + flutter test
#   shell            a shell in the container
#
# Example: scripts/build.sh gen go-android apk

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

IMAGE=localhost/githeft-toolchain
NDK_VERSION=28.2.13676358
ANDROID_API=24
OUT=build/outputs

die() { echo "error: $*" >&2; exit 1; }

in_container() {
  podman image exists "$IMAGE" || cmd_toolchain
  local tty=()
  [ -t 0 ] && tty=(-it)
  podman run --rm "${tty[@]}" --ulimit nofile=65536:65536 \
    -v "$REPO_ROOT:/src:Z" \
    -v githeft-gradle:/root/.gradle \
    -v githeft-android:/root/.android \
    -v githeft-pub:/root/.pub-cache \
    -v githeft-gomod:/opt/go/pkg/mod \
    -v githeft-gocache:/root/.cache/go-build \
    -w /src \
    "$IMAGE" bash -euo pipefail -c "$1"
}

cmd_toolchain() {
  echo "==> Building the toolchain image (cached after the first run)"
  podman build --ulimit nofile=65536:65536 -f Containerfile --target toolchain -t "$IMAGE" .
}

cmd_gen() {
  # buf and the Go plugins run on the host (go install, see README);
  # protoc-gen-dart comes from the container (scripts/protoc-gen-dart).
  echo "==> Generating Go and Dart code"
  podman image exists "$IMAGE" || cmd_toolchain
  PATH="$(go env GOPATH)/bin:$PATH"
  command -v buf >/dev/null || die "buf missing: go install github.com/bufbuild/buf/cmd/buf@latest"
  buf lint
  buf generate --template buf.gen.go.yaml
  buf generate --template buf.gen.dart.yaml 2> >(grep -v -e 'as root' -e 'superuser' -e '^ *$' -e '^ */$' -e '📎' >&2)
}

cmd_go_android() {
  echo "==> Building libgitheft.so for Android"
  in_container "
    tc=/opt/android-sdk/ndk/$NDK_VERSION/toolchains/llvm/prebuilt/linux-x86_64/bin
    for t in arm64-v8a:arm64:aarch64-linux-android x86_64:amd64:x86_64-linux-android armeabi-v7a:arm:armv7a-linux-androideabi; do
      IFS=: read -r abi arch triple <<< \"\$t\"
      out=app/android/app/src/main/jniLibs/\$abi
      mkdir -p \$out
      CGO_ENABLED=1 GOOS=android GOARCH=\$arch GOARM=7 CC=\$tc/\${triple}$ANDROID_API-clang \
        go build -buildmode=c-shared -trimpath \
          -ldflags '-s -w -extldflags=-Wl,-z,max-page-size=16384' \
          -o \$out/libgitheft.so ./ffi
      rm -f \$out/libgitheft.h
      echo \"    \$abi: \$(du -h \$out/libgitheft.so | cut -f1)\"
    done"
}

cmd_go_linux() {
  echo "==> Building libgitheft.so for Linux"
  in_container '
    CGO_ENABLED=1 CC=clang go build -buildmode=c-shared -trimpath -ldflags "-s -w" -o build/go/linux-x64/libgitheft.so ./ffi
    rm -f build/go/linux-x64/libgitheft.h'
}

cmd_apk() {
  local mode="${1:-release}"
  [ -f app/android/app/src/main/jniLibs/arm64-v8a/libgitheft.so ] || cmd_go_android
  echo "==> Building the $mode APK"
  # Signed with the debug key from the githeft-android volume, so each build
  # installs over the previous one.
  in_container "
    export PUB_CACHE=/root/.pub-cache
    cd app
    printf 'flutter.sdk=/opt/flutter\nsdk.dir=/opt/android-sdk\n' > android/local.properties
    flutter pub get
    flutter build apk --$mode
    mkdir -p ../$OUT
    cp build/app/outputs/flutter-apk/app-$mode.apk ../$OUT/githeft-$mode.apk"
  echo "==> $OUT/githeft-$mode.apk"
}

cmd_linux() {
  cmd_go_linux
  echo "==> Building the Linux bundle"
  in_container "
    export PUB_CACHE=/root/.pub-cache
    cd app
    flutter pub get
    flutter build linux --release
    rm -rf ../$OUT/githeft-linux
    mkdir -p ../$OUT
    cp -r build/linux/x64/release/bundle ../$OUT/githeft-linux
    # The command next to the app runs the background sync timer.
    cd ..
    CGO_ENABLED=0 go build -trimpath -ldflags '-s -w' -o $OUT/githeft-linux/githeft-cli ./cmd/githeft"
  echo "==> $OUT/githeft-linux/githeft"
}

cmd_web() {
  echo "==> Building the web app"
  in_container '
    export PUB_CACHE=/root/.pub-cache
    cd app
    flutter pub get
    flutter build web --release --no-web-resources-cdn'
  echo "==> app/build/web"
}

cmd_cli() {
  echo "==> Building the githeft command"
  in_container "CGO_ENABLED=0 go build -trimpath -ldflags '-s -w' -o $OUT/githeft ./cmd/githeft"
  echo "==> $OUT/githeft"
}

cmd_analyze() {
  in_container '
    export PUB_CACHE=/root/.pub-cache
    cd app
    flutter pub get >/dev/null
    flutter analyze
    dart format --output=none --set-exit-if-changed lib/main.dart lib/state.dart lib/backend lib/screens lib/widgets'
}

cmd_format() {
  in_container '
    export PUB_CACHE=/root/.pub-cache
    cd app
    dart format lib/main.dart lib/state.dart lib/backend lib/screens lib/widgets'
}

cmd_test() {
  in_container '
    go test ./...
    export PUB_CACHE=/root/.pub-cache
    cd app
    flutter pub get >/dev/null
    flutter test'
}

[ $# -gt 0 ] || { awk 'NR > 2 && /^#/ { sub(/^# ?/, ""); print; next } NR > 2 { exit }' "$0"; exit 1; }
while [ $# -gt 0 ]; do
  command=$1
  shift
  case "$command" in
    toolchain) cmd_toolchain ;;
    gen) cmd_gen ;;
    go-android) cmd_go_android ;;
    go-linux) cmd_go_linux ;;
    apk)
      if [ "${1:-}" = debug ] || [ "${1:-}" = release ]; then cmd_apk "$1"; shift; else cmd_apk; fi ;;
    linux) cmd_linux ;;
    web) cmd_web ;;
    cli) cmd_cli ;;
    analyze) cmd_analyze ;;
    format) cmd_format ;;
    test) cmd_test ;;
    shell) in_container bash ;;
    *) die "unknown command $command" ;;
  esac
done
