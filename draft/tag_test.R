x = E
mediaDir = wavDir
tags = c('feat_summary', 'audio_time')
filesRange = 1:30
subj.id = 'subjectid'
media.id = 'base_name'
mc.cores = parallel::detectCores()
subj.id.simplify = FALSE
features = 'f0'
extraFeatures = FALSE
gender = "u"
windowShift = 5
numFormants = 8
numcep = 12
dcttype = c("t2", "t1", "t3", "t4")
fbtype = c("mel", "htkmel", "fcmel", "bark")
resolution = 40
usecmp = FALSE
full.names = TRUE
recursive = FALSE
check.mono = TRUE
stereo2mono = TRUE
overwrite = FALSE
freq = 44100
round.to = 4
