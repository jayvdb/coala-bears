R.exe -e "install.packages('formatR')"
R.exe -e "install.packages('lintr')"

R.exe -e "library(lintr)" -e "lintr::lint('.ci/deps.r')"
