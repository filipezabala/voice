# # downloading public domain audio
# url1 <- 'https://archive.org/download/adventuressherlockholmes_v4_1501_librivox/adventuresofsherlockholmes_01_doyle_128kb.mp3'
# cmd1 <- paste0('cd ~/Downloads; wget -r -np -k ', url1)
# system(cmd1)
#
# setwd('~/Dropbox/D_Filipe_Zabala/pacotes/voiceAudios/')
# cmd2 <- 'cd ~/Dropbox/D_Filipe_Zabala/pacotes/voiceAudios/; for i in *.[Mm][Pp]3; do ffmpeg -i "$i" "${i%.*}.wav"; done'
# system(cmd2)

# libs
library(voice)
library(tidyverse)
library(VIM)
library(gridExtra)

# font url
url0 <- 'https://github.com/filipezabala/voiceAudios/raw/main/mp3/'

# mp3 files
mp3Files <- c('anthem0.mp3', 'anthem1.mp3', 'anthem2.mp3',
              'game0.mp3', 'game1.mp3', 'game2.mp3',
              'phantom0.mp3', 'phantom1.mp3',  'phantom2.mp3',
              'romeo0.mp3', 'romeo1.mp3', 'romeo2.mp3',
              'sherlock0.mp3', 'sherlock1.mp3', 'sherlock2.mp3',
              'war0.mp3', 'war1.mp3', 'war2.mp3')

# downloading mp3 files
for(i in mp3Files){
  system(paste0('wget -r -np -k ', url0, i, ' -P ~/Downloads'))
}

# tidying up files and directories
system('mkdir ~/Downloads/voiceAudios/')
system('mkdir ~/Downloads/voiceAudios/mp3')
system('cp ~/Downloads/github.com/filipezabala/voiceAudios/raw/main/mp3/*.* ~/Downloads/voiceAudios/mp3')
system('rm -rf ~/Downloads/github.com/')


# wd
setwd('~/Downloads/voiceAudios')

# files and directories
wavDir <- paste0(getwd(), '/wav')
rttmDir <- paste0(getwd(), '/rttm')
splitDir <- paste0(getwd(), '/split')
ifelse(!dir.exists(wavDir), dir.create(wavDir), 'Directory exists!')
ifelse(!dir.exists(rttmDir), dir.create(rttmDir), 'Directory exists!')
ifelse(!dir.exists(splitDir), dir.create(splitDir), 'Directory exists!')

# converting mp3 to wav
# cmd3 <- 'cd ~/Downloads/voiceAudios/mp3;
# for i in *.[Mm][Pp]3; do ffmpeg -i "$i" "../wav/${i%.*}.wav"; done'
# system(cmd3)
wavFiles <- dir(wavDir, pattern = '[Ww][Aa][Vv]', full.names = T)

# wav > mp3 > wav n times. spent time, cut accuracy, features accuracy
 # ffmpeg
 # tuneR?
 # audio?
 # ...?

# mp3 > wav n times. spent time, cut accuracy, features accuracy

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
ef <- voice::extract_features(splitDir, features = c('f0','formants'), round.to = 6)
Sys.time()-ini # Time difference of 30.30654 secs
ef # nrow = 49284

# assign notes
note <- lapply(ef[-1], notes)
note <- bind_rows(note)
colnames(note) <- paste0('note_', colnames(note))
ef <- bind_cols(ef, note)
ef

# FDA empírica
# plot(ecdf(freq), pch = '.')
# plot(cumsum(knots(ecdf(freqhalf))), pch = '+', col = 'red')
# qplot(y=freq, x= 1, geom = "boxplot") +
#   geom_hline(yintercept=mean(freq))


# creating tibble
ini <- Sys.time()
spl <- strsplit(ef$file_name, '[_.]')
names(spl) <- 1:length(spl)
spl <- bind_cols(spl)
spl <- t(spl)
ef$record <- spl[,1]
ef$name <- unlist(strsplit(ef$record, '[0-9]'))
ef$male <- rep(0, nrow(ef))
ef[ef$name %in% c(unique(ef$name)[4:6]),]$male <- 1
ef <- ef %>%
  dplyr::relocate(file_name, record, name, male, starts_with('note'), F0:last_col())
  # dplyr::relocate(file_name, record, name, male, note, F0)
ef$male <- as.factor(ef$male)
ef.na0 <- na.omit(ef)
glimpse(ef)
dim(ef)
dim(ef.na0)
Sys.time()-ini # Time difference of 1.502251 secs

# # scaling
# ef.sc <- scale(ef[,-(1:5)])
# ef.sc <- cbind(ef[,1:5], ef.sc)
# glimpse(ef.sc)
#
# ef.na0.sc <- scale(ef.na0[,-(1:5)])
# ef.na0.sc <- cbind(ef.na0[,1:5], ef.na0.sc)
# glimpse(ef.na0.sc)

# # NA
# na <- aggr(ef, sortVars = T)

# distance
nd <- music::noteDistance(as.character(dur$note))
nd <- music::noteDistance(as.character(ef$note_F0))
table(nd)
nd.name <- by(as.character(ef$note_F0), ef$name, music::noteDistance)
tab.name <- lapply(nd.name, table)
lapply(tab.name, prop.table)

nd.male <- by(as.character(ef$note_F0), ef$male, music::noteDistance)
tab.male <- lapply(nd.male, table)
lapply(tab.male, prop.table)


# duration
dur <- voice::duration(ef$note_F0)

library(music)
is.na(dur$note[1:10])
playNote(note = as.character(dur$note[3:9]))
playNote(note = as.character(dur$note[3:9]),
         duration = dur$dur_line[3:9])
playProgression(as.character(dur$note[3:9]),
                duration = 1:7)


library(tabr)

x <- phrase("c ec'g' ec'g'", "4 4 2", "5 432 432")
x <- track(x)
x <- score(x)
outfile <- file.path(tempdir(), "out.pdf")
tab(x, outfile) # requires LilyPond installation

(p1 <- p("r4 a,8 c f d a f"))
p1 %>% track() %>% score() %>%
  tab("phrase.pdf", key = "dm", time = "4/4", tempo = "4 = 120")



# plots
par(mfrow = c(2,3))

# for(i in 1:length(unique(ef$record) )){
  ini <- Sys.time()
  fltr <- ef$record == unique(ef$record)[1]
  plot(1:nrow(ef[fltr,]), ef[fltr,]$note_F0, pch = '-', xaxt = 'n', yaxt = 'n',
       ylab = 'note_F0', xlab = 'slice')
  axis(1, at = 1:nrow(ef[fltr,]), labels = 1:nrow(ef[fltr,]), las = 2, cex.axis = 0.8)
  axis(2, at = 1:length(levels(ef$note_F0)), labels = levels(ef$note_F0), las = 2)
  table(ef[fltr,]$note_F0)
  print(Sys.time()-ini)
# }


# plot(freq[1:54])
# points(freqhalf[1:54], col = 'red')
# hist(freq)
# boxplot(freq)
# points(freqhalf)


ef$note#[20:55, drop = TRUE]
barplot(table(ef$note))#[20:55, drop = TRUE]))
(taby <- by(ef$note, ef$male, table)) # 0: Gß1/Ab1-Fß4/Gb4, 1: G1-B3
(propby <- lapply(taby, prop.table))

red <- rgb(1, 0, 0, alpha=0.5)
blue <- rgb(0, 0, 1, alpha=0.5)
barplot(propby$`0`, space = 0, col = red)
barplot(propby$`1`, space = 0, col = blue, add = TRUE)




# F0-F8
p1 <- ggplot(ef, aes(x=F0, fill=male)) +
  geom_density(alpha=.3)
p2 <- ggplot(ef, aes(x=F1, fill=male)) +
  geom_density(alpha=.3)
p3 <- ggplot(ef, aes(x=F2, fill=male)) +
  geom_density(alpha=.3)
p4 <- ggplot(ef, aes(x=F3, fill=male)) +
  geom_density(alpha=.3)
p5 <- ggplot(ef, aes(x=F4, fill=male)) +
  geom_density(alpha=.3)
p6 <- ggplot(ef, aes(x=F5, fill=male)) +
  geom_density(alpha=.3)
p7 <- ggplot(ef, aes(x=F6, fill=male)) +
  geom_density(alpha=.3)
p8 <- ggplot(ef, aes(x=F7, fill=male)) +
  geom_density(alpha=.3)
p9 <- ggplot(ef, aes(x=F8, fill=male)) +
  geom_density(alpha=.3)
grid.arrange(p1,p2,p3,p4,p5,p6,p7,p8,p9, ncol=3)

# ZCR, MHS, RMS, GAIN
p1 <- ggplot(ef, aes(x=ZCR1, fill=male)) +
  geom_density(alpha=.3)
p2 <- ggplot(ef, aes(x=MHS, fill=male)) +
  geom_density(alpha=.3)
p3 <- ggplot(ef, aes(x=RMS, fill=male)) +
  geom_density(alpha=.3)
p4 <- ggplot(ef, aes(x=GAIN, fill=male)) +
  geom_density(alpha=.3)
grid.arrange(p1,p2,p3,p4, ncol=2)

# RCF
p1 <- ggplot(ef, aes(x=RFC1, fill=male)) +
  geom_density(alpha=.3)
p2 <- ggplot(ef, aes(x=RFC2, fill=male)) +
  geom_density(alpha=.3)
p3 <- ggplot(ef, aes(x=RFC3, fill=male)) +
  geom_density(alpha=.3)
p4 <- ggplot(ef, aes(x=RFC4, fill=male)) +
  geom_density(alpha=.3)
p5 <- ggplot(ef, aes(x=RFC5, fill=male)) +
  geom_density(alpha=.3)
p6 <- ggplot(ef, aes(x=RFC6, fill=male)) +
  geom_density(alpha=.3)
p7 <- ggplot(ef, aes(x=RFC7, fill=male)) +
  geom_density(alpha=.3)
p8 <- ggplot(ef, aes(x=RFC8, fill=male)) +
  geom_density(alpha=.3)
p9 <- ggplot(ef, aes(x=RFC9, fill=male)) +
  geom_density(alpha=.3)
grid.arrange(p1,p2,p3,p4,p5,p6,p7,p8,p9, ncol=3)

# ACF
p1 <- ggplot(ef, aes(x=ACF1, fill=male)) +
  geom_density(alpha=.3)
p2 <- ggplot(ef, aes(x=ACF2, fill=male)) +
  geom_density(alpha=.3)
p3 <- ggplot(ef, aes(x=ACF3, fill=male)) +
  geom_density(alpha=.3)
p4 <- ggplot(ef, aes(x=ACF4, fill=male)) +
  geom_density(alpha=.3)
p5 <- ggplot(ef, aes(x=ACF5, fill=male)) +
  geom_density(alpha=.3)
p6 <- ggplot(ef, aes(x=ACF6, fill=male)) +
  geom_density(alpha=.3)
p7 <- ggplot(ef, aes(x=ACF7, fill=male)) +
  geom_density(alpha=.3)
p8 <- ggplot(ef, aes(x=ACF8, fill=male)) +
  geom_density(alpha=.3)
p9 <- ggplot(ef, aes(x=ACF9, fill=male)) +
  geom_density(alpha=.3)
grid.arrange(p1,p2,p3,p4,p5,p6,p7,p8,p9, ncol=3)

# MFCC
p1 <- ggplot(ef, aes(x=MFCC1, fill=male)) +
  geom_density(alpha=.3)
p2 <- ggplot(ef, aes(x=MFCC2, fill=male)) +
  geom_density(alpha=.3)
p3 <- ggplot(ef, aes(x=MFCC1, fill=male)) +
  geom_density(alpha=.3)
p4 <- ggplot(ef, aes(x=MFCC4, fill=male)) +
  geom_density(alpha=.3)
p5 <- ggplot(ef, aes(x=MFCC5, fill=male)) +
  geom_density(alpha=.3)
p6 <- ggplot(ef, aes(x=MFCC6, fill=male)) +
  geom_density(alpha=.3)
p7 <- ggplot(ef, aes(x=MFCC7, fill=male)) +
  geom_density(alpha=.3)
p8 <- ggplot(ef, aes(x=MFCC8, fill=male)) +
  geom_density(alpha=.3)
p9 <- ggplot(ef, aes(x=MFCC9, fill=male)) +
  geom_density(alpha=.3)
grid.arrange(p1,p2,p3,p4,p5,p6,p7,p8,p9, ncol=3)

# train-test


# models
# CART | rpart::rpart
library(rpart)
library(rpart.plot)

ini <- Sys.time()
fit <- rpart(male ~ F0, data = ef[,-c(1:3,5)])
rpart.plot(fit)
Sys.time()-ini # Time difference of 26.06224 secs

# logistic binomial | stats::glm
ini <- Sys.time()
fit0 <- glm(male ~ ., data = ef.na0.sc[,-(1:4)], family = 'binomial')
summary(fit0)
Sys.time()-ini # Time difference of 8.293075 secs

ini <- Sys.time()
fit1 <- step(fit0)
Sys.time()-ini #

# h20::automl
library(h2o)


# partiture
# https://flujoo.github.io/gm/articles/gm.html
library(gm)
library(magick)
str(magick::magick_config())

tiger <- image_read_svg('http://jeroen.github.io/images/tiger.svg', width = 350)
print(tiger)
image_write(tiger, path = "tiger.png", format = "png")
tiger_png <- image_convert(tiger, "png")
image_info(tiger_png)
image_display(tiger)
image_browse(tiger)

m <- Music()
m <- m +
  # add a 4/4 time signature
  Meter(4, 4) +
  # add a musical line of a C5 whole note
  Line(pitches = list("C5"), durations = list("whole"))
gm::show(m, to = c("score", "audio"))

m <- m + Line(
  pitches = list("C3", "G3"),
  durations = list("half", "half")
)
m
show(m)

if (interactive()) {
  m <- Music() + Meter(4, 4) + Line(list("C4"), list(4))
  show(m, c("score", "audio"), "-r 800 -T 5")
}

m <-
  # initialize a Music object
  Music() +
  # add a 4/4 time signature
  Meter(4, 4) +
  # add a musical line of four quarter notes
  Line(list("C5", "D5", "E5", "F5"), list(1, 1, 1, 1))

show(m)



# # writing csv
# ini <- Sys.time()
# write_csv(ef, '~/Dropbox/D_Filipe_Zabala/pacotes/voiceAudios/csv/ef.csv')
# Sys.time()-ini # Time difference of 4.174057 secs

# exploratory
table(ef$name)
by(ef, ef$name, summary)
