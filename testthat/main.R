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

# updatig and creating manual
devtools::document(setwd('~/Dropbox/[D] Filipe Zabala/pacotes/voice/'))

# loading
devtools::load_all()

# installing and attaching
devtools::install_github('filipezabala/voice', force = T)
library(voice)
?rp
?conv_df

