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
# ef

# # NA
# na <- aggr(ef, sortVars = T)

# conv
(ef <- voice::conv_df(ef, .01))
# (ef <- voice::conv_df(ef, .01, weight = ef$GAIN))

# assign notes
note <- lapply(ef[-c(1,ncol(ef))], voice::notes)
note <- bind_rows(note)
colnames(note) <- paste0('note_', colnames(note))
ef <- bind_cols(ef, note)

midi <- lapply(ef[colnames(note)], voice::notes, method = 'midi')
note <- bind_rows(note)
colnames(note) <- paste0('note_', colnames(note))
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

midi <- c(60,61,62,63)

library(gm)
m <- Music()
m <- m +
  # add a 4/4 time signature
  Meter(4, 4) +
  # add a musical line of a C5 whole note
  Line(pitches = list(),
       durations = list(1))
m
export(m, '~/Desktop/', "x2", c("musicxml"), "-r 200 -b 520")

?music::buildChord()


library(audio)
# record 8000 samples at 8000Hz (1 sec), mono (1 channel)
a <- record(8000, 8000, 1)
wait(a) # wait for the recording to finish
x <- a$data # get the result
x[1:10] # show first ten samples
close(a); rm(a) # you can close the instance at this point
play(x) # play back the result




