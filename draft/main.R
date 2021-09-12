# https://cran.r-project.org/web/packages/policies.html
# CRAN-submissions@R-project.org (for submissions) or CRAN@R-project.org (for published packages)

# main file
# http://r-pkgs.had.co.nz/

# Some useful keyboard shortcuts for package authoring:
#
#   Install Package:           'Cmd + Shift + B'
#   Check Package:             'Cmd + Shift + E'
#   Test Package:              'Cmd + Shift + T'

# packs
# sudo apt-get install libgit2-dev
# library(devtools)

# session_info
# session_info()

# updating and creating manual
devtools::document(setwd('~/Dropbox/D_Filipe_Zabala/pacotes/voice/'))

devtools::install_github('filipezabala/voice')

# # loading
# devtools::load_all()

# checking
# https://kalimu.github.io/post/checklist-for-r-package-submission-to-cran/

# usethis::use_build_ignore(c('draft', 'cran-comments.md'))
devtools::check()
devtools::check(args = c('--as-cran'))
# devtools::check_win_devel()
# devtools::check_win_oldrelease()
# devtools::check_win_release()
usethis::use_github_actions()
goodpractice::gp()

# Run R CMD check on all downstream dependencies
dep = tools::package_dependencies(reverse = TRUE, which = 'Depends', recursive = TRUE)
deplgc = sapply(dep, is.chr0)
depT = which(!deplgc)
listFull = vector('list', length(depT))
j = 0
for(i in depT){
  j = j+1
  listFull[[j]] = dep[[i]]
  names(listFull)[[j]] = names(depT[j])
}
listUn = sort(unique(unlist(listFull)))
# tools::package_dependencies(reverse = TRUE)
# tools::check_packages_in_dir('~/Dropbox/D_Filipe_Zabala/pacotes/voice/', reverse = list())
# https://github.com/r-lib/revdepcheck
revdepcheck::revdep_check(num_workers = 4)
revdepcheck::revdep_reset()

#
# # OLD
# revdep_check(libpath = "../revdep")
# chooseCRANmirror(ind = 11)
#
# library(revdepcheck)
# path = '/Users/filipezabala/Dropbox/D_Filipe_Zabala/pacotes/voice'
# revdep_check(path, num_workers = 4, quiet = FALSE)
# revdep_check(num_workers = 4)
# revdep_summary()                 # table of results by package
# revdep_details(".", "<package>") # full details for the specified package
# revdep_report()
#
# devtools::revdep_check()
# devtools::revdep_check_save_summary()
# devtools::revdep_check_print_problems()
# devtools::check_cran()


# https://cran.r-project.org/submit.html

devtools::install()
# sending to CRAN
devtools::spell_check()

.libPaths()

# $ R CMD check /Users/filipezabala/Dropbox/D_Filipe_Zabala/pacotes/voice
# $ R CMD build /Users/filipezabala/Dropbox/D_Filipe_Zabala/pacotes/voice
# $ R CMD INSTALL /Users/filipezabala/Dropbox/D_Filipe_Zabala/pacotes/voice/voice_0.0.0.9000.tar.gz

# https://stackoverflow.com/questions/14358814/error-in-r-cmd-check-packages-required-but-not-available/59894631#59894631
# https://stackoverflow.com/questions/7505547/detach-all-packages-while-working-in-r
sessionInfo()
invisible(suppressMessages(suppressWarnings(lapply(c("gsl","fBasics","stringr","stringi","Rmpfr"), require, character.only = TRUE))))
invisible(suppressMessages(suppressWarnings(lapply(names(sessionInfo()$loadedOnly), require, character.only = TRUE))))
sessionInfo()

# https://community.rstudio.com/t/r-hub-builder-there-is-no-package-called-utf8/65694
rhub::check(platform="windows-x86_64-devel",
            env_vars=c(R_COMPILE_AND_INSTALL_PACKAGES = "always") )

devtools::check_rhub()
devtools::release()


# 54 #' my_colors <- RColorBrewer::brewer.pal(5, 'Spectral')
# 55 #' my_colors <- grDevices::colorRampPalette(my_colors)(100)
# 61 #' ellipse::plotcorr(data_ord , col=my_colors[data_ord*50+50] , mar=c(1,1,1,1))
# 68 #' ggplot2::autoplot(pc, data = na.omit(ef2), colour = 'file_name',

# installing
update.packages(ask=F)
devtools::install_github('filipezabala/voice')

# attaching
library(voice)
?wsw
?conv_df
?conv_mc
?extract_features
?expand_model
?is_mono
find.package('voice')
packageDescription('voice')
citation('voice')
