set -x
set -e

# making coala cache the dependencies downloaded upon first run
echo '' > /tmp/dummy

coala --ci -V --bears CheckstyleBear --files /tmp/dummy --no-config --bear-dirs bears
coala --ci -V --bears ScalaLintBear --files /tmp/dummy --no-config --bear-dirs bears

rm /tmp/dummy
