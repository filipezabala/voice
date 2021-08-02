# wd
setwd('~/Dropbox/D_Filipe_Zabala/audios/testes/')

# libs
library(voice)
library(VIM)
library(music)

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
ef <- voice::extract_features(splitDir, features = c('f0','formants'),
                              round.to = 6, windowShift = 100)
Sys.time()-ini # Time difference of 30.30654 secs
ef # nrow = 49284

# NA
na <- aggr(ef, sortVars = T)

# assign notes
note <- lapply(ef[-1], notes)
note <- bind_rows(note)
colnames(note) <- paste0('note_', colnames(note))
ef <- bind_cols(ef, note)
ef

# creating tibble
ini <- Sys.time()
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
Sys.time()-ini

# distance
nd <- music::noteDistance(as.character(ef$note_F0))
table(nd)

# duration
dur <- voice::duration(ef$note_F0, 100)

#playing
playNote(note = as.character(dur$note))
