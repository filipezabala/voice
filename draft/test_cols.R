library(voice)

(M <- extract_features('~/Documents/wavDirSample/',
                       features = c('lps'),
                       filesRange = 441:450)) # 1028

?extract_features

# get path to audio file
path2wav <- list.files(system.file('extdata', package = 'wrassp'),
                       pattern <- glob2rx('*.wav'), full.names = TRUE)

# minimal usage
(M1 <- extract_features(path2wav))
