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

  paste('python3 ./temp_temp_diarization-pyannote.py', directory)

}
