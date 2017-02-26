# making coala cache the dependencies downloaded upon first run
echo '' > dummy
coala-ci --bears CheckstyleBear --files dummy --no-config --bear-dirs bears || true
coala-ci --bears ScalaLintBear --files dummy --no-config --bear-dirs bears || true
