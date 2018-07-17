#!/usr/bin/env bash

# Non-zero exit code is what we want to check
set +e

# Enable capturing the non-zero exit status of setup.py instead of tee
set -o pipefail

set -x

# Many bear dependencies do not install on unsupported versions
echo "" > bear-requirements.txt

python setup.py install | tee setup.log

retval=$?

set +x

# coalib.__init__.py should exit with 4 on unsupported versions of Python
# If setup.py emits something else.
if [[ $retval != 4 ]]; then
  echo "Unexpected error code $?"

  # When the exit code is 0, use a non-zero exit code instead
  if [[ $retval == 0 ]]; then
    exit 127
  fi
  exit $retval
fi

# error when no lines selected by grep
set -e

grep -q 'coala supports only python 3.4.4 or later' setup.log

echo "Unsupported check completed successfully"
