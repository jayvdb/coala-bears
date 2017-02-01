# Delete bears
set -e

if [[ "$BEARS" == "all" ]]; then
  echo "No bears pruned."
  exit 0
fi


#rm $(comm -23 <(ls bears/*/[A-Za-z]*.py | grep -v general | sort) <(grep -l PipRequirement bears/*/*.py | sort))
#      rm bears/general/CPDBear.py
#      rm bears/generate_package.py
      
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

distribution_only_bears=$(grep -Pl 'DistributionRequirement\(' $other_requirement_bears)

# Verify that DistributionRequirement is the only other Requirement subclass used
unknown_requirement_bears=$(grep -Pl '(?<!Distribution)Requirement\(' $other_requirement_bears || true)

if [[ -n "$unknown_requirement_bears" ]]; then
  echo "Unknown requirements for $unknown_requirement_bears"
  exit 1
fi

echo Cabal $cabal_requirement_bears
echo Gem $gem_requirement_bears
echo Go $go_requirement_bears
echo Npm $npm_requirement_bears
echo R $rscript_requirement_bears
echo Distro $distribution_only_bears

pip_only_requirement_bears=$(comm -23 <(ls $pip_requirement_bears) <(ls $non_pip_runtime_requirement_bears))
pip_plus_requirement_bears=$(comm -23 <(ls $pip_requirement_bears) <(ls $pip_only_requirement_bears))

echo Pip $pip_only_requirement_bears
echo Pip-plus $pip_plus_requirement_bears

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

echo Clang $clang_bears

executable_linter_bears=$(grep -m 1 -l '@linter(executable=' $other_bears)
executable_other_bears=$(grep -m 1 -l 'run_shell_command' $other_bears)

echo Other exe: $executable_linter_bears $executable_other_bears

other_bears=$(comm -23 <(ls $other_bears) <(ls $executable_linter_bears $executable_other_bears))

echo Unknown $other_bears

non_yield_result_other_bears=$(comm -23 <(ls $other_bears) <(ls $yield_result_bears))

if [[ -n "$non_yield_result_other_bears" ]]; then
  echo "Unknown bear type $non_yield_result_other_bears"
  exit 1
fi

python_bears="$pip_only_requirement_bears $clang_bears $other_bears"

echo Python $python_bears

non_python_bears=$(comm -23 <(ls $bears) <(ls $python_bears))

echo Non-Python $non_python_bears

if [[ $BEARS == "python" ]]; then
  rm $non_python_bears
  # The test for generate_package depends on non-Python bears
  rm bears/generate_package.py
fi

source .ci/bears.dirs.prune.sh
