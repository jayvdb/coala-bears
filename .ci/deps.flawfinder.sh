#!/bin/sh
# Change environment for flawfinder from python to python2
if [ ! -e ~/.local/bin/flawfinder ]; then
  cp /usr/bin/flawfinder ~/.local/bin/flawfinder
  sed -i '1s/.*/#!\/usr\/bin\/env python2/' ~/.local/bin/flawfinder
  chmod +x ~/.local/bin/flawfinder
fi
