if VERSION < v"0.7.0-DEV.5183"
  Pkg.clone(pwd())
  Pkg.build(ENV["JL_PKG"])
else
  using Pkg
  Pkg.build()
end
