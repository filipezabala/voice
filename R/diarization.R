#' Diarization (who speaks when?) from WAV audios using Python's pyannote-audio library.
#'
#' @param directory A directory/folder containing WAV files.
#' @param extension The extension of audio files to be extracted. Case sensitive.
#' @examples
#' path2wav <- list.files(system.file('extdata', package = 'wrassp'),
#' pattern <- glob2rx('*.wav'), full.names = TRUE)
#' diarization(path2wav, '.wav')
#' @export
diarization <- function(directory, extension,
                        condacall = '~/miniconda3/envs/py38phdz/bin/python'){

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

  condacall = '~/miniconda3/envs/py38phdz/bin/python'
  directory <- dirname(path2wav)[1]
  cmd <- paste(condacall, '-m temp_diarization-pyannote', directory)
  system(cmd, wait = FALSE, intern = T)
}
