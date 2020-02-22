## TESTS
library(parallel)
library(wrassp)
library(warbleR)
library(tidyverse)
library(tuneR)

# get path to audio file
path2wav <- list.files(system.file("extdata", package = "wrassp"),
                       pattern = glob2rx("*.wav"),
                       full.names = TRUE)
# path2mp3 <- "/Users/filipezabala/Dropbox/D_Filipe_Zabala/pacotes/voice/aa.mp3"

# calculate fundamental frequency contour
xx <- extract_features(dirname(path2wav))
ncol(xx)
xx

xx2 <- extract_features(dirname(path2wav),
                        features = c('f0','formants','zcr','rms','mhs',
                                     'gain','rfc','ac','mfcc'))
ncol(xx2)
xx2

xx3 <- extract_features(dirname(path2wav),
                        features = c('f0'))
ncol(xx3)
xx3

# # manually try extract_features()
# x <- dirname(path2wav)
# gender = 'u'
# windowShift = 5
# numFormants = 8
# numcep = 12
# dcttype = c('t2', 't1', 't3', 't4')
# fbtype = c('mel', 'htkmel', 'fcmel', 'bark')
# usecmp = FALSE
# mc.cores = parallel::detectCores()
# convert.mp3 = FALSE
# dest.path = NULL
# full.names = TRUE
# recursive = FALSE
# as.tibble = TRUE
# resolution = 40
# features = c('f0')
# features = c('f0','formants','zcr','rms','mhs',
#              'gain','rfc','ac','cep','dft','css',
#              'lps','mfcc')
