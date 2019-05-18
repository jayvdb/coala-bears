#!/bin/sh

set -e
set -x

echo 'options(repos=structure(c(CRAN="http://cran.rstudio.com")))' >> .Rprofile
