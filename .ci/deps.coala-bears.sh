# making coala cache the dependencies downloaded upon first run
echo '' > dummy

find ~/.local/share/coala-bears

rm ~/.local/share/coala-bears/CheckstyleBear/checkstyle-6.15.jar || true

coala-ci --bears CheckstyleBear --files dummy --no-config --bear-dirs bears || true
coala-ci --bears ScalaLintBear --files dummy --no-config --bear-dirs bears || true

find ~/.local/share/coala-bears

file ~/.local/share/coala-bears/CheckstyleBear/checkstyle-6.15.jar

java -jar ~/.local/share/coala-bears/CheckstyleBear/checkstyle-6.15.jar -c /google_checks.xml tests/java/test_files/CheckstyleGood.java
java -jar ~/.local/share/coala-bears/CheckstyleBear/checkstyle-6.15.jar -c /google_checks.xml tests/java/test_files/CheckstyleBad.java
