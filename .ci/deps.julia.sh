#julia -e "Pkg.add(\"Lint\")"

#julia -e "import Lint.lintfile"

#mkdir deps
#echo 'Pkg.add("Lint")' > deps/build.jl

#cat Manifest.toml || true

# Normal package management not possible due to
# https://github.com/tonyhffong/Lint.jl/issues/254
julia -e 'using Pkg; Pkg.add(PackageSpec(url="https://github.com/tonyhffong/Lint.jl", rev="v0.6.0"))'
