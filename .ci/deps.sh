#!/bin/bash

set -e
set -x

.ci/deps.node_js.sh

.ci/deps.gem.sh

.ci/deps.dart.sh

.ci/deps.perl.sh

.ci/deps.julia.sh

.ci/deps.lua.sh

.ci/deps.php.sh

.ci/deps.flawfinder.sh
