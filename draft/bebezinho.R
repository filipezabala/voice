# libs
library(voice)
library(VIM)
library(music)
library(tidyverse)

# wd
setwd('~/Dropbox/D_Filipe_Zabala/audios/testes/')

# files and directories
wavDir <- paste0(getwd(), '/wav')
rttmDir <- paste0(getwd(), '/rttm')
splitDir <- paste0(getwd(), '/split')
ifelse(!dir.exists(wavDir), dir.create(wavDir), 'Directory exists!')
ifelse(!dir.exists(rttmDir), dir.create(rttmDir), 'Directory exists!')
ifelse(!dir.exists(splitDir), dir.create(splitDir), 'Directory exists!')



# converting mp3 to wav
cmd <- 'cd ~/Dropbox/D_Filipe_Zabala/audios/testes/mp3;
for i in *.[Mm][Pp]3; do ffmpeg -i "$i" "../wav/${i%.*}.wav"; done'
system(cmd)
wavFiles <- dir(wavDir, pattern = '[Ww][Aa][Vv]', full.names = T)

# (who) speaks when?
ini <- Sys.time()
voice::wsw(wavDir, to = rttmDir, pycall = '~/miniconda3/envs/pyvoice38/bin/python3.8')
Sys.time()-ini # Time difference of 11.34808 mins

# split wave
ini <- Sys.time()
voice::splitw(wavDir, fromRttm = rttmDir, to = splitDir)
Sys.time()-ini # Time difference of 4.870748 secs




# extract features
ini <- Sys.time()
ef <- voice::extract_features(splitDir, features = c('f0','formants','gain'),
                              round.to = 6, windowShift = 5)
Sys.time()-ini
ef

plot(ef$F0,ef$GAIN)

# # NA
# na <- aggr(ef, sortVars = T)

# conv
ef <- voice::conv_df(ef, .02)

# assign notes
note <- lapply(ef[-c(1,ncol(ef))], notes)
note <- bind_rows(note)
colnames(note) <- paste0('note_', colnames(note))
ef <- bind_cols(ef, note)
ef

# creating tibble
spl <- strsplit(ef$file_name, '[_.]')
names(spl) <- 1:length(spl)
spl <- bind_cols(spl)
spl <- t(spl)
ef$record <- spl[,1]
ef$name <- unlist(strsplit(ef$record, '[0-9]'))
ef <- ef %>%
  dplyr::relocate(file_name, record, name, starts_with('note'), F0:last_col())
glimpse(ef)
dim(ef)

# distance
nd <- music::noteDistance(as.character(ef$note_F0))
table(nd)

# duration
dur <- voice::duration(ef$note_F0)
# dur <- duration(ef$note_F0, 100)
dur

# play
music::playNote(note = as.character(dur$note),
                duration = dur$dur_line)





library(audio)
# record 8000 samples at 8000Hz (1 sec), mono (1 channel)
a <- record(8000, 8000, 1)
wait(a) # wait for the recording to finish
x <- a$data # get the result
x[1:10] # show first ten samples
close(a); rm(a) # you can close the instance at this point
play(x) # play back the result



## OLD
music::playFreq

?music::freq2wave

x <- rep(NA_real_, 16000)
# start recording into x
record(x, 8000, 1)
# monitor the recording progress
par(ask=FALSE) # for continuous plotting
while (is.na(x[length(x)])) plot(x, type='l', ylim=c(-1, 1))
# play the recorded audio
play(x)

library(music)
library(audio)
library(seewave)
note = as.character(dur$note)
freqs <- note2freq(note, A4 = 440)
playFreq(freqs, duration = c(.5,1,.1,1,1,1))
?playWave
playWave(freq2wave(440), plot = T)

buildChord("B4", "sus2", play = TRUE)

c(mapply(freq2wave, frequency, oscillator, duration,
         BPM, sample.rate, attack.time, inner.release.time))

d <- rep(1, length(note))
d[1] <- .


wave <- freq2wave(note2freq(as.character(dur$note)),
                  duration = 1,
                  attack.time = 100,
                  inner.release.time = 5,
                  plot = TRUE)
audio::play(wave)


audio::play(as.character(dur$note))
audio::play(sin(1:10000/20))
