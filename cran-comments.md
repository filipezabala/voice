## Test environments
* local OS X install 10.15.7 (19H15), R 4.0.3 Patched (2020-12-24 r79685)
* ubuntu 20.04.1 LTS, R 4.0.3

## R CMD check results
There were no ERRORs or WARNINGs.

There was 1 NOTE:

  * checking for future file timestamps ... NOTE
  unable to verify current time

## Downstream dependencies
I insistently tried to carry out the verification, published my questions in 2020-12-27 on [this](https://github.com/r-lib/revdepcheck/issues/291) and [this](https://community.rstudio.com/t/revdepcheck-problems/28305) links and I am still studying how to perform this task.

rhub::check(
  platform="windows-x86_64-devel",
  env_vars=c(R_COMPILE_AND_INSTALL_PACKAGES = "always")
)
