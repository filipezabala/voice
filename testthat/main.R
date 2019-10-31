# main file
# http://r-pkgs.had.co.nz/

# Some useful keyboard shortcuts for package authoring:
#
#   Install Package:           'Cmd + Shift + B'
#   Check Package:             'Cmd + Shift + E'
#   Test Package:              'Cmd + Shift + T'

# packs
library(devtools)

# session_info
session_info()

# creating manual
devtools::document(setwd('~/Dropbox/[D] Filipe Zabala/pacotes/voice/'))

# loading jurimetrics
devtools::load_all()
search()

# installing and attaching jurimetrics
devtools::install_github('filipezabala/voice', force = T)
library(voice)



