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


library(ellipse)
library(RColorBrewer)

# Usando o famoso banco de dados 'mtcars'
data <- cor(cor(xx[-1]))

# Painel de 100 cores com Rcolor Brewer
my_colors <- brewer.pal(5, "Spectral")
my_colors <- colorRampPalette(my_colors)(100)

# Ordenando a matriz de correlação
ord <- order(data[1, ])
data_ord <- data[ord, ord]
plotcorr(data_ord , col=my_colors[data_ord*50+50] , mar=c(1,1,1,1))
