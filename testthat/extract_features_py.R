# packs
library(tidyverse)

getwd()
l <- system('python3 ./testthat/extract_f0.py /Users/filipezabala/Dropbox/D_Filipe_Zabala/audios/coorte',
            wait = FALSE, intern = T)

l <- sapply(l, strsplit, ',')
l <- lapply(l, as.numeric)
lapply(l, quantile, probs=seq(0,1,.01))
