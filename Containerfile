# Toolchain for building Githeft without installing anything on the host:
# Android SDK + NDK, Flutter (Android, Linux desktop and web), Go and the
# protobuf code generators. scripts/build.sh runs builds in it with the
# checkout mounted, and scripts/emulator.sh uses the `emulator` stage.
#
# The first layers match GitJournal's Containerfile.android, so a machine
# that built that already has them cached.

ARG BASE_IMAGE=docker.io/library/eclipse-temurin:17-jdk-jammy
ARG ANDROID_CMDLINE_TOOLS_URL=https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
ARG ANDROID_PLATFORM=android-36
ARG ANDROID_BUILD_TOOLS=36.0.0
ARG ANDROID_NDK=28.2.13676358
ARG FLUTTER_VERSION=3.41.9

FROM ${BASE_IMAGE} AS toolchain

ENV DEBIAN_FRONTEND=noninteractive \
    ANDROID_SDK_ROOT=/opt/android-sdk \
    ANDROID_HOME=/opt/android-sdk \
    FLUTTER_HOME=/opt/flutter \
    PUB_CACHE=/opt/pub-cache \
    TAR_OPTIONS=--no-same-owner
ENV PATH="${FLUTTER_HOME}/bin:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools:${PATH}"

RUN apt-get update && apt-get install -y --no-install-recommends \
        curl git unzip xz-utils zip ca-certificates \
    && rm -rf /var/lib/apt/lists/*

ARG ANDROID_CMDLINE_TOOLS_URL
ARG ANDROID_PLATFORM
ARG ANDROID_BUILD_TOOLS
ARG ANDROID_NDK
RUN mkdir -p "${ANDROID_SDK_ROOT}/cmdline-tools" \
    && curl -fsSL -o /tmp/cmdline-tools.zip "${ANDROID_CMDLINE_TOOLS_URL}" \
    && unzip -q /tmp/cmdline-tools.zip -d "${ANDROID_SDK_ROOT}/cmdline-tools" \
    && mv "${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools" "${ANDROID_SDK_ROOT}/cmdline-tools/latest" \
    && rm /tmp/cmdline-tools.zip \
    && yes | sdkmanager --licenses > /dev/null \
    && sdkmanager \
        "platform-tools" \
        "platforms;${ANDROID_PLATFORM}" \
        "build-tools;${ANDROID_BUILD_TOOLS}" \
        "ndk;${ANDROID_NDK}" > /dev/null

ARG FLUTTER_VERSION
RUN git clone --depth 1 -b "${FLUTTER_VERSION}" https://github.com/flutter/flutter.git "${FLUTTER_HOME}" \
    && git config --global --add safe.directory "${FLUTTER_HOME}" \
    && flutter config --no-analytics --no-cli-animations \
    && flutter precache --android \
    && flutter doctor -v

WORKDIR /app

# Linux desktop and web on top of the Android toolchain.
RUN apt-get update && apt-get install -y --no-install-recommends \
        clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev file \
    && rm -rf /var/lib/apt/lists/* \
    && flutter config --enable-linux-desktop --enable-web \
    && flutter precache --linux --web

ARG GO_VERSION=1.26.0
ENV GOROOT=/usr/local/go GOPATH=/opt/go GOTOOLCHAIN=local
ENV PATH="/usr/local/go/bin:/opt/go/bin:${PUB_CACHE}/bin:${PATH}"
RUN curl -fsSL "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" | tar -xz -C /usr/local

# protoc-gen-dart for the Dart messages and gRPC client. buf runs on the
# host and calls it through scripts/protoc-gen-dart.
ARG PROTOC_PLUGIN_VERSION=25.1.0
RUN dart pub global activate protoc_plugin "${PROTOC_PLUGIN_VERSION}"

# Flutter's native-assets build step on Linux needs ld.lld and llvm-ar.
RUN apt-get update && apt-get install -y --no-install-recommends lld llvm \
    && rm -rf /var/lib/apt/lists/*

# Android emulator for trying the app (scripts/emulator.sh); needs /dev/kvm.
FROM toolchain AS emulator
ENV PATH="${ANDROID_SDK_ROOT}/emulator:${PATH}"
RUN apt-get update && apt-get install -y --no-install-recommends \
        libpulse0 libnss3 libxcomposite1 libxcursor1 libxi6 libxtst6 libasound2 libgl1 libxdamage1 \
        libxkbfile1 libxrandr2 libdbus-1-3 libx11-xcb1 libxkbcommon0 libfontconfig1 libglib2.0-0 libegl1 \
        python3 \
    && rm -rf /var/lib/apt/lists/*
ARG EMULATOR_IMAGE="system-images;android-35;default;x86_64"
RUN sdkmanager "emulator" "${EMULATOR_IMAGE}" > /dev/null \
    && echo no | avdmanager create avd -n test -k "${EMULATOR_IMAGE}" -d pixel_6 > /dev/null
ARG SCRCPY_VERSION=v5.0.1
RUN curl -fsSL "https://github.com/Genymobile/scrcpy/releases/download/${SCRCPY_VERSION}/scrcpy-linux-x86_64-${SCRCPY_VERSION}.tar.gz" \
        | tar -xz -C /opt \
    && ln -s "/opt/scrcpy-linux-x86_64-${SCRCPY_VERSION}/scrcpy" /usr/local/bin/scrcpy
