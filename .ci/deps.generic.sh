#!/bin/sh
if [ -n "$BEARS" ]; then
  for BEAR in $BEARS $BEAR_LIST; do
    if [ -f ".ci/deps.$BEAR.sh" ]; then
      bash -e -x ".ci/deps.$BEAR.sh"
    fi
  done
fi
