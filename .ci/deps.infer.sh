#!/bin/sh
INFER_URL="https://github.com/facebook/infer/releases/download/v$INFER_VERSION/infer-linux64-v$INFER_VERSION.tar.xz"
curl -sSL "$INFER_URRL" | tar -C ~/ -xJ
