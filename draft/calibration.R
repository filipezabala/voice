# calibration
library(voice)
library(tidyverse)

# dir
vaDir <- '~/Downloads/voiceAudios'
wavDir <- paste0(vaDir, '/wav')
rttmDir <- paste0(vaDir, '/rttm')
splitDir <- paste0(vaDir, '/split')
mxmlDir <- paste0(vaDir, '/musicxml')
ifelse(!dir.exists(vaDir), dir.create(vaDir), 'Directory exists!')
ifelse(!dir.exists(wavDir), dir.create(wavDir), 'Directory exists!')
ifelse(!dir.exists(rttmDir), dir.create(rttmDir), 'Directory exists!')
ifelse(!dir.exists(splitDir), dir.create(splitDir), 'Directory exists!')
ifelse(!dir.exists(mxmlDir), dir.create(mxmlDir), 'Directory exists!')

# file
url0 <- 'https://github.com/filipezabala/voiceAudios/raw/main/wav/bebezinho_2.005.wav'
download.file(url0, paste0(wavDir, '/bebezinho_2.005.wav'), mode = 'wb')

# ef
ef <- voice::extract_features(wavDir, features = c('f0','formants','gain'),
                              round.to = 6, windowShift = 5)
ef

# plots
par(mfrow=c(2,3))
# plot(ef$GAIN)
plot(ef$F0)
plot(zoo::rollmean(ef$F0, 7), main = 'rollmean_7')
plot(zoo::rollmean(ef$F0, 11), main = 'rollmean_11')
plot(zoo::rollmean(ef$F0, 2^4+1), main = 'rollmean_2^4+1')
plot(zoo::rollmean(ef$F0, 2^5+1), main = 'rollmean_2^5+1')
plot(zoo::rollmean(ef$F0, 2^6+1), main = 'rollmean_2^6+1')
# plot(zoo::rollmean(ef$F0, 2^7+1), main = 'rollmean_2^7+1')

# Pooling
(ef01 <- voice::conv_df(ef, .01)) # 1%

# Assign notes
spn <- lapply(ef01[2:10], voice::notes)
spn <- bind_rows(spn)
colnames(spn) <- paste0('spn_', colnames(spn))
ef01 <- bind_cols(ef01, spn)

midi <- lapply(ef01[2:10], voice::notes, method = 'midi')
midi <- bind_rows(midi)
colnames(midi) <- paste0('midi_', colnames(midi))
ef01 <- bind_cols(ef01, midi)
glimpse(ef01)

# Distance (in semitones)
nd.spn <- music::noteDistance(as.character(ef01$spn_F0))
table(nd.spn) # semitones

# Get duration
dur.spn <- voice::duration(ef01$spn_F0)
dur.midi <- voice::duration(ef01$midi_F0)

