# https://cran.r-project.org/web/packages/soundgen/vignettes/acoustic_analysis.html#audio-segmentation

# libraries
library(tuneR) # setWavPlayer, readMP3, writeWave
# library(warbleR) # chackwaves, mp32wav
library(soundgen) # spectrogram, segment
library(beepr) # beepr::beep

# setting wav player
setWavPlayer("/Library/Audio/playRWave")

# reading mp3 audios
setwd('~/Dropbox/[D] Filipe Zabala/audios/coorte/')
setwd('~/Dropbox/[D] Filipe Zabala/audios/testes/')
(mp3Files <- list.files(getwd(), pattern = glob2rx('*.mp3'), 
                        full.names = F, recursive = T))
n <- length(mp3Files)
mp3 <- sapply(mp3Files, readMP3)
mp3
play(mp3[[1]])


# # converting mp3 to wav
# wav <- vector('list',n)
# for(i in 1:n){
#   writeWave(mp3[[i]], paste0(mp3Files[[i]],'.wav'), extensible=FALSE)
#   print(i/n)
# }
# mp32wav()

# reading wav audios
# setwd('~/Dropbox/[D] Filipe Zabala/audios/coorte/')
# setwd('~/Dropbox/[D] Filipe Zabala/audios/testes/')
# (wavFiles <- list.files(getwd(), pattern = glob2rx('*.wav'), 
#                         full.names = F, recursive = T))
# nWav <- length(wavFiles)
# wav <- sapply(wavFiles, readWave)
# wav
# play(wav[[1]])

# signals
signalLeft <- vector('list', n)
signalRight <- vector('list', n)
names(signalLeft) <- mp3Files
names(signalRight) <- mp3Files

for(i in 1:n){
  signalLeft[[i]] <- as.numeric(mp3[[i]]@left)
  signalRight[[i]] <- as.numeric(mp3[[i]]@right)
  print(i/n)
}

# plots
plot(mp3[[1]], main = mp3Files[1]) # 11718

# spectrogram
# ini <- Sys.time()
# spectrogram(signalLeft[[1]], samplingRate = mp3[[1]]@samp.rate)
# beepr::beep(8)
# Sys.time()-ini # Time difference of 9.928882 mins

# cutting voice
ini <- Sys.time()
ss1 <- segment(signalLeft[[1]], samplingRate = mp3[[1]]@samp.rate, 
               plot = TRUE, windowLength = 25)
# beepr::beep(1)
Sys.time()-ini # Time difference of 11.71895 secs
ss1

play(mp3[[1]])



# miliseconds to seconds + miliseconds
# m2s <- function(x){
#   s <- x %/% 1000
#   m <- x %% 1000
#   return(data.frame(sec = s, mili = m))
# }
# m2s(288.1054)
# m2s(ss1$syllables$start[4])
# m2s(ss1$syllables$end[4])


# Self-similarity matrix
# ini <- Sys.time()
# m <- ssm(wav[[1]], samplingRate = wav[[1]]@samp.rate)
# beepr::beep(1)
# Sys.time()-ini


# modulationSpectrum
# ms = modulationSpectrum(s, samplingRate = 16000, logWarp = NULL,
# windowLength = 25, step = 25)