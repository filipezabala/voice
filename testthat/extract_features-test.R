# packs
library(tidyverse)
library(voice)
library(reticulate)

# extraction via parselmouth.Sound.to_pitch, pitch_ceiling = 600.0
ini <- Sys.time()
# f0_py <- system('python3 ./testthat/extract_f0.py /Users/filipezabala/Dropbox/D_Filipe_Zabala/audios/coorte',
#             wait = FALSE, intern = T)
f0_py <- extract_features_py('/Users/filipezabala/Dropbox/D_Filipe_Zabala/audios/coorte')
Sys.time()-ini # Time difference of 4.468059 secs, 9.350217 secs
f0_py <- sapply(f0_py, strsplit, ',')
f0_py <- lapply(f0_py, as.numeric)
lapply(f0_py, quantile, probs=seq(0,1,.01))
lapply(f0_py, length)

# extraction via wrassp::ksvF0, maxF = 600
ini <- Sys.time()
f0_R <- extract_features('/Users/filipezabala/Dropbox/D_Filipe_Zabala/audios/coorte',
                         'f0')
Sys.time()-ini # Time difference of 5.339381 secs, 15.13803 secs
by(f0_R$F0, f0_R$audio, quantile, probs=seq(0,1,.01))
by(f0_R$F0, f0_R$audio, length)


ef_py <- extract_features_py('/Users/filipezabala/Dropbox/D_Filipe_Zabala/audios/coorte')

lapply(ef_py, quantile, probs=seq(0,1,.1))
lapply(ef_py, length)
