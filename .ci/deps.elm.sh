if [ "$TRAVIS_ELM_VERSION" = "0.18.0" ]; then
  touch elm-package.json
else
  touch elm.json
fi
