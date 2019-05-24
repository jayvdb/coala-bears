if [ -n "$BEARS" ]; then
  if [ -f ".ci/deps.$BEARS.sh" ]; then
    bash -e -x .ci/deps.$BEARS.sh
  fi
fi
