#julia -e "Pkg.add(\"Lint\")"

#julia -e "import Lint.lintfile"

#mkdir deps
#echo 'Pkg.add("Lint")' > deps/build.jl

cat Manifest.toml || true
