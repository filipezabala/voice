# packs
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
(ef01 <- voice::conv_df(ef, .01))
(ef01w <- voice::conv_df(ef, .01, weight = ef$GAIN))

# assign notes
spn <- lapply(ef01[2:10], voice::notes)
spn <- bind_rows(spn)
colnames(spn) <- paste0('spn_', colnames(spn))
ef01 <- bind_cols(ef01, spn)

midi <- lapply(ef01[2:10], voice::notes, method = 'midi')
midi <- bind_rows(midi)
colnames(midi) <- paste0('midi_', colnames(midi))
ef01 <- bind_cols(ef01, midi)

# # creating tibble
# spl <- strsplit(ef$file_name, '[_.]')
# names(spl) <- 1:length(spl)
# spl <- bind_cols(spl)
# spl <- t(spl)
# ef$record <- spl[,1]
# ef$name <- unlist(strsplit(ef$record, '[0-9]'))
# ef <- ef %>%
#   dplyr::relocate(file_name, record, name, starts_with('spn'),
#                   starts_with('midi'), F0:last_col())
# glimpse(ef)
# dim(ef)

# distance
ef01$spn_F0
nd <- music::noteDistance(as.character(ef01$spn_F0))
table(nd) # semitones

# duration
dur.spn <- voice::duration(ef01$spn_F0)
dur.midi <- voice::duration(ef01$midi_F0)

# play
music::playNote(note = as.character(dur.spn$note),
                duration = dur.spn$dur_line)

# partiture
dur.midi$note
dur.midi$dur_line

library(gm)
m <- Music()
m <- m +
  # add a 4/4 time signature
  Meter(4, 4) +
  # add a musical line of a C5 whole note
  Line(pitches = list(51, 53, 61, 58),
       durations = list(1,1,1,1))
  # Line(pitches = list(50, 49, 61, 58),
  #      durations = list(1,1,1,2))
  # Line(pitches=list(51,50,51,54,55,56,57,54,55,54,50,52,49,50),
  #      durations = list(1,1,1,1,1,1,1,1,2,1,1,1,1,2))
m
path <- paste0(getwd(), '/musicxml')
export(m, path, "bebezinho", c("musicxml"), "-r 200 -b 520")

?music::buildChord()


library(audio)
# record 8000 samples at 8000Hz (1 sec), mono (1 channel)
a <- record(8000, 8000, 1)
wait(a) # wait for the recording to finish
x <- a$data # get the result
x[1:10] # show first ten samples
close(a); rm(a) # you can close the instance at this point
play(x) # play back the result



# library(tabr)
# tabr::chord_is_major(as.character(dur.spn$note))
# x <- "c cg, ce ce_ ceg ce_gb g,ce g,ce_ e_,g,c e_,g,ce_ e_,g,c"
# chord_is_major(x)
# identical(chord_is_major(x), !chord_is_minor(x))



