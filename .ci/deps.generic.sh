#!/bin/sh
if [ -n "$BEARS" ]; then
  for BEAR in $BEARS; do
    if [ -f ".ci/deps.$BEARS.sh" ]; then
      bash -e -x .ci/deps.$BEARS.sh
    fi
  done
fi
