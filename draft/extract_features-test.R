# packs
library(tidyverse)
library(voice)

# extraction via parselmouth.Sound.to_pitch, pitch_ceiling = 600.0
ini <- Sys.time()
# ef_py <- extract_features_py('~/Dropbox/D_Filipe_Zabala/audios/coorte', filesRange = 2:7)
ef_py <- extract_features_py('/Library/Frameworks/R.framework/Versions/4.0/Resources/library/wrassp/extdata/',
                             filesRange = 2:7)
Sys.time()-ini
by(ef_py$F0, ef_py$file_name, quantile, probs=seq(0,1,.1), na.rm = T)
by(ef_py$F0, ef_py$file_name, function(x) sum(is.nan(x))/length(x))
lapply(ef_py, length)
by(ef_py$F0, ef_py$file_name, length)

# extraction via wrassp::ksvF0, maxF = 600
ini <- Sys.time()
ef_R <- extract_features('~/Dropbox/D_Filipe_Zabala/audios/coorte/wav/',
                         c('f0', 'formants'), mc.cores = 1)
Sys.time()-ini # Time difference of 5.339381 secs, 15.13803 secs
by(f0_R$F0, f0_R$audio, quantile, probs=seq(0,1,.1))
by(f0_R$F0, f0_R$audio, length)


ef_py <- extract_features_py('/Users/filipezabala/Dropbox/D_Filipe_Zabala/audios/coorte')

lapply(ef_py, quantile, probs=seq(0,1,.1))
lapply(ef_py, length)
