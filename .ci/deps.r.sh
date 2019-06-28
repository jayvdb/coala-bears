#!/bin/sh

set -e
set -x

# R commands
echo '.libPaths( c( "/usr/local/lib/R/site-library", .libPaths()) )' >> ~/.Rprofile
echo 'options(repos=structure(c(CRAN="http://cran.rstudio.com")))' >> .Rprofile
#R -q -e 'install.packages("lintr")'
#R -q -e 'install.packages("formatR")'
