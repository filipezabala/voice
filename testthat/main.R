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
devtools::document(setwd('~/Dropbox/D_Filipe_Zabala/pacotes/voice/'))

# loading
devtools::load_all()

# installing and attaching
update.packages(ask=F)
devtools::install_github('filipezabala/voice', force = T)
library(voice)
?conv_df
?extract_features
