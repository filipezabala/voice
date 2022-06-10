library(voice)

# get path to audio file
path2wav <- list.files(system.file('extdata', package = 'wrassp'),
                       pattern <- glob2rx('*.wav'), full.names = TRUE)


directory = dirname(path2wav)
filesRange = NULL
features = c('f0','formants','zcr','mhs','rms',
             'gain','rfc','ac','mfcc')
gender = 'u'
windowShift = 5
numFormants = 8
numcep = 12
dcttype = c('t2', 't1', 't3', 't4')
fbtype = c('mel', 'htkmel', 'fcmel', 'bark')
resolution = 40
usecmp = FALSE
mc.cores = parallel::detectCores()
full.names = TRUE
recursive = FALSE
check.mono = TRUE
stereo2mono = TRUE
overwrite = FALSE
freq = 44100
round.to = 4
