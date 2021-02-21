#' Diarization (who speaks when?) from WAV audios using Python's pyannote-audio library.
#'
#' @param directory A directory/folder containing WAV files.
#' @export
diarization <- function(directory){

  # process time
  pt0 <- proc.time()

  # removing duplicates, using the first directory provided
  directory <- directory[1]

  # # getting python functions - MUST BE A BETTER WAY TO DO THIS!
  if(!file.exists(paste0(getwd(),'/temp_libs.py'))){
    utils::download.file('https://raw.githubusercontent.com/filipezabala/voice/master/tests/libs.py',
                         'temp_libs.py')
  }

  if(!file.exists(paste0(getwd(),'/temp_diarization-pyannote.py'))){
    utils::download.file('https://raw.githubusercontent.com/filipezabala/voice/master/tests/diarization-pyannote.py',
                         'temp_diarization-pyannote.py')
  }


  setwd('~/Dropbox/D_Filipe_Zabala/thesis/')
  directory <- '~/Dropbox/D_Filipe_Zabala/audios/coorte/wav/'
  cmd2 <- paste('~/miniconda3/envs/py38phdz/bin/python ./temp_diarization-pyannote.py', directory)
  system(cmd2, wait = FALSE, intern = T)

}
