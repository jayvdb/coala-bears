if [ -z "$TRAVIS_LANGUAGE" ]; then
  bundle install --path=vendor/bundle --binstubs=vendor/bin --jobs=8 --retry=3
fi
