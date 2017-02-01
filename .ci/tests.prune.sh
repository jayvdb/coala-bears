# Delete tests for bears that have been removed
set -e

for test in tests/generate_packageTest.py tests/*/[A-Za-z]*.py; do
  bear=${test/Test.py/.py}
  bear=${bear/tests/bears}
  if [[ ! -f $bear ]]; then
    echo Removing $test
    rm $test
  fi
done
