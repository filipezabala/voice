library(seewave)

# your audio file (using example file from seewave package)
data(tico)
audio <- tico # this is an S4 class object
# the frequency of your audio file
freq <- 22050
# the length and duration of your audio file
totlen <- length(audio)
totsec <- totlen/freq

# the duration that you want to chop the file into
seglen <- 0.5

# defining the break points
breaks <- unique(c(seq(0, totsec, seglen), totsec))
index <- 1:(length(breaks)-1)
# a list of all the segments
subsamps <- lapply(index, function(i) cutw(audio, f=freq, from=breaks[i], to=breaks[i+1]))
audiomod <- audio[(freq*breaks[1]):(freq*breaks[length(breaks)-1])] # remove unequal part at end
replicate(100,matrix(audiomod@left,ncol=length(breaks)))
replicate(100,matrix(audiomod@right,ncol=length(breaks)))
