# setting environment
pycall <- '~/miniconda3/envs/pyvoice38/bin/python3.8'
reticulate::use_condaenv(pycall, required = TRUE)
parselmouth <- reticulate::import('parselmouth')

# files
file_list <- list.files(system.file('extdata', package = 'wrassp'),
                        pattern = glob2rx('*.wav'), full.names = TRUE)
fl <- file_list[1]

# F0 extraction
snd <- parselmouth$Sound(fl)
pitch <- snd$to_pitch(time_step = 5/1000)
interval <- seq(pitch$start_time, pitch$end_time, 5/1000)
f0_praat <- sapply(interval, pitch$get_value_at_time)
f0_praat[is.nan(f0_praat)] <- NA
f0_sv <- voice::extract_features(fl, features = c('f0', 'f0_mhs'))

# checking
length(f0_sv$f0)
length(f0_sv$f0_mhs)
length(f0_praat)

summary(f0_sv$f0)
summary(f0_sv$f0_mhs)
summary(f0_praat)


# formants extraction
snd <- parselmouth$Sound(fl)
max_formants <- 8
fmt <- snd$to_formant_burg(time_step = 5/1000, max_number_of_formants = max_formants)
interval <- seq(fmt$start_time, fmt$end_time, 5/1000)

#TODO: build with apply
fmt_praat <- matrix(nrow = length(interval), ncol = max_formants)
colnames(fmt_praat) <- paste0('fmt_', 1:max_formants)
for(i in 1:max_formants){
  for(j in 1:length(interval)){
    fmt_praat[j,i] <- fmt$get_value_at_time(formant_number = as.integer(i),
                                            time = interval[j])
  }
}
fmt_praat[is.nan(fmt_praat)] <- NA




# testing extract_features 0.4.20
x <- list.files(system.file('extdata', package = 'wrassp'),
                       pattern = glob2rx('*.wav'), full.names = TRUE)

features = c('f0', 'fmt',
             'f0_mhs',
             'f0_praat', 'fmt_praat')
filesRange = NULL
sex = 'u'
windowShift = 5
numFormants = 8
numcep = 12
dcttype = c('t2', 't1', 't3', 't4')
fbtype = c('mel', 'htkmel', 'fcmel', 'bark')
resolution = 40
usecmp = FALSE
mc.cores = 1
full.names = TRUE
recursive = FALSE
check.mono = FALSE
stereo2mono = FALSE
overwrite = FALSE
freq = 44100
round.to = NULL
verbose = FALSE
pycall = '~/miniconda3/envs/pyvoice38/bin/python3.8'

