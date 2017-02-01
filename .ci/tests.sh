set -e
set -x

source .ci/env_variables.sh

args=()

if [ "$system_os" == "LINUX" ] ; then
  args+=('--cov' '--cov-fail-under=100' '--cov-append' '--doctest-modules')
fi

python3 -m pytest "${args[@]}"
