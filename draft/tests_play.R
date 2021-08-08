# tests
# devtools::install_github('flujoo/gm')
# install.packages('magick', dep = T)

library(gm)
m <- Music()
m <- m +
  # add a 4/4 time signature
  Meter(4, 4) +
  # add a musical line of a C5 whole note
  Line(pitches = list("C5"), durations = list("whole"))
m
gm::show(m, to = c("score", "audio"))
gm::export(m, '~/Desktop/', 'm', 'mp3')

if (interactive()) {
  m <- Music() + Meter(4, 4) + Line(list("C4"), list(4))
  export(m, tempdir(), "x", c("musicxml"), "-r 200 -b 520")
  export(m, '~/Desktop/', "x", c("musicxml"), "-r 200 -b 520")
}
gm:::Music


# play
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
