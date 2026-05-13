# Document
devtools::document('~/Dropbox/zabalab/voice/voice/')

# Check
devtools::check('~/Dropbox/zabalab/voice/voice/')

# Check "--as-cran"
devtools::check(args = c("--as-cran"))

# Using rcmdcheck package (more detailed output)
rcmdcheck::rcmdcheck(args = c("--as-cran"))

# Base R method
tools::check_packages_in_dir("~/Dropbox/zabalab/voice/voice/",
                             flags = c("--as-cran"))

# Submitting to CRAN
devtools::submit_cran('~/Dropbox/zabalab/voice/voice/')
