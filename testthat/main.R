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

# updating and creating manual
devtools::document(setwd('~/Dropbox/D_Filipe_Zabala/pacotes/voice/'))

# loading
devtools::load_all()

# installing
update.packages(ask=F)
devtools::install_github('filipezabala/voice', force = T)

# attaching
library(voice)
?conv_df
?conv_mc
?extract_features
