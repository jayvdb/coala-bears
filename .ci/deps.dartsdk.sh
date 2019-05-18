#!/bin/bash

set -e -x

# Dart Lint commands
if ! dartanalyzer -v &> /dev/null; then
  wget -nc -O ~/dart-sdk.zip https://storage.googleapis.com/dart-archive/channels/stable/release/1.14.2/sdk/dartsdk-linux-x64-release.zip
  unzip -n ~/dart-sdk.zip -d ~/
  cp -rp ~/dart-sdk/* ~/.local/
fi
