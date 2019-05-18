#!/bin/sh

set -e
set -x

echo '.libPaths( c( "/usr/local/lib/R/site-library", .libPaths()) )' >> ~/.Rprofile
echo 'options(repos=structure(c(CRAN="http://cran.rstudio.com")))' >> .Rprofile
