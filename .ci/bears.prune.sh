# Delete bears
set -e

if [[ "$BEARS" == "all" ]]; then
  echo "No bears pruned."
  exit 0
fi

if [[ -z "$BEARS" ]]; then
  if [[ -n "$TRAVIS_LANGUAGE" ]]; then
    BEARS=$TRAVIS_LANGUAGE
  fi
fi

if [[ "$BEARS" == "haskell" || "$BEARS" == "ghc" ]]; then
  BEARS=cabal
elif [[ "$BEARS" == "ruby" ]]; then
  BEARS=gem
elif [[ "${BEARS/node/}" != "$BEARS" ]]; then
  BEARS=npm
elif [[ "$BEARS" == "r" ]]; then
  BEARS=rscript
elif [[ "$BEARS" == "generic" ]]; then
  BEARS=apt-get
fi

bears=$(find bears -type f -and -name '*Bear.py' | sort)

yield_result_bears=$(grep -m 1 -l 'yield Result' $bears)

non_yield_result_bears=$(comm -23 <(ls $bears) <(ls $yield_result_bears))

requirement_bears=$(grep -m 1 -l 'Requirement(' $bears)

cabal_requirement_bears=$(grep -m 1 -l CabalRequirement $requirement_bears)
gem_requirement_bears=$(grep -m 1 -l GemRequirement $requirement_bears)
go_requirement_bears=$(grep -m 1 -l GoRequirement $requirement_bears)
npm_requirement_bears=$(grep -m 1 -l NpmRequirement $requirement_bears)
rscript_requirement_bears=$(grep -m 1 -l RscriptRequirement $requirement_bears)

pip_requirement_bears=$(grep -m 1 -l PipRequirement $requirement_bears)

non_pip_runtime_requirement_bears="$cabal_requirement_bears $gem_requirement_bears $go_requirement_bears $npm_requirement_bears $rscript_requirement_bears"

other_requirement_bears=$(comm -23 <(ls $requirement_bears) <(ls $non_pip_runtime_requirement_bears $pip_requirement_bears))

distribution_requirement_bears=$(grep -m 1 -l 'DistributionRequirement(' $requirement_bears)

apt_get_requirement_bears=$(grep -m 1 -l 'apt_get' $distribution_requirement_bears)

# Verify that DistributionRequirement is the only other Requirement subclass used
unknown_requirement_bears=$(grep -m 1 -Pl '(?<!Distribution)Requirement\(' $other_requirement_bears || true)

if [[ -n "$unknown_requirement_bears" ]]; then
  echo "Unknown requirements for $unknown_requirement_bears"
  exit 1
fi

pip_only_requirement_bears=$(comm -23 <(ls $pip_requirement_bears) <(ls $non_pip_runtime_requirement_bears))
pip_plus_requirement_bears=$(comm -23 <(ls $pip_requirement_bears) <(ls $pip_only_requirement_bears))

no_requirement_bears=$(comm -23 <(ls $bears) <(ls $requirement_bears))

clang_bears=''
other_bears=''
for bear in $no_requirement_bears; do
  if [[ ${bear/Clang/} != $bear ]]; then
    clang_bears="$clang_bears $bear"
  else
    other_bears="$other_bears $bear"
  fi
done

executable_linter_bears=$(grep -m 1 -l '@linter(executable=' $other_bears)
executable_other_bears=$(grep -m 1 -l 'run_shell_command' $other_bears)

other_bears=$(comm -23 <(ls $other_bears) <(ls $executable_linter_bears $executable_other_bears))

non_yield_result_other_bears=$(comm -23 <(ls $other_bears) <(ls $yield_result_bears))

if [[ -n "$non_yield_result_other_bears" ]]; then
  echo "Unknown bear type $non_yield_result_other_bears"
  exit 1
fi

python_bears="$pip_only_requirement_bears $clang_bears $other_bears"

non_python_bears=$(comm -23 <(ls $bears) <(ls $python_bears))

cabal_requirement_bears="$cabal_requirement_bears bears/haskell/HaskellLintBear.py bears/shell/ShellCheckBear.py"
apt_get_requirement_bears=$(echo $apt_get_requirement_bears | xargs -n 1 | egrep -v '(Haskell|Julia|Lua)' )

remove_bears=''

echo Removing bears not desirable for $BEARS

if [[ $BEARS == "python" ]]; then
  # The test for generate_package depends on non-Python bears
  remove_bears="$non_python_bears"
elif [[ $BEARS == "cabal" ]]; then
  remove_bears=$(comm -23 <(ls $bears) <(ls $cabal_requirement_bears))
elif [[ $BEARS == "gem" ]]; then
  remove_bears=$(comm -23 <(ls $bears) <(ls $gem_requirement_bears))
elif [[ $BEARS == "go" ]]; then
  remove_bears=$(comm -23 <(ls $bears) <(ls $go_requirement_bears))
elif [[ $BEARS == "npm" ]]; then
  remove_bears=$(comm -23 <(ls $bears) <(ls $npm_requirement_bears))
elif [[ $BEARS == "rscript" ]]; then
  remove_bears=$(comm -23 <(ls $bears) <(ls $rscript_requirement_bears))
elif [[ $BEARS == "apt-get" ]]; then
  remove_bears=$(comm -23 <(ls $bears) <(ls $apt_get_requirement_bears))
fi

if [[ -n "$remove_bears" ]]; then
  # generate_package.py only needs testing with BEARS=all
  remove_bears="bears/generate_package.py $remove_bears"
fi

for bear in $remove_bears; do
  echo Removing $bear
  rm $bear
done

source .ci/bears.dirs.prune.sh
