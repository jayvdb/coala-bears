# This must be `source`d, and kept very basic to avoid breaking travis shell
if [ "$TRAVIS_LANGUAGE" = "ruby" ]; then
  # https://travis-ci.community/t/bundle-path-disappears/4260
  export BUNDLE_PATH="$TRAVIS_BUILD_DIR/vendor/bundle"
  export BUNDLE_BIN="$BUNDLE_PATH/bin"
  EXTRA_PATH="$BUNDLE_BIN"
elif [ "$TRAVIS_LANGUAGE" = "java" ]; then
  EXTRA_PATH="$HOME/.local/tailor/tailor-latest/bin"
elif [ "$TRAVIS_LANGUAGE" = "php" ]; then
  EXTRA_PATH="$TRAVIS_BUILD_DIR/vendor/bin"
elif [ "$TRAVIS_LANGUAGE" = "node_js" ]; then
  # Travis adds ./node_modules/.bin , but some tests change directory
  EXTRA_PATH="$TRAVIS_BUILD_DIR/node_modules/.bin"
elif [ "$BEARS" = "lua" ]; then
  EXTRA_PATH="$HOME/.luarocks/bin"
fi

if [ -n "$EXTRA_PATH" ]; then
  echo EXTRA_PATH=$EXTRA_PATH
  export PATH="$PATH:$EXTRA_PATH"
fi
