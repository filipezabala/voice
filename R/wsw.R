#'  Who Speaks When? Diarization from WAV audios using Python's pyannote-audio library.
#'
#' @param from A directory/folder containing WAV files.
#' @param to A directory/folder to write RTTM files.
#' @param pycall Python call.
#' @examples
#' path2wav <- list.files(system.file('extdata', package = 'wrassp'),
#' pattern <- glob2rx('*.wav'), full.names = TRUE)
#' dir.create(paste0(dirname(path2wav)[1], '/rttm/'))
#' wsw(dirname(path2wav)[1])
#' @export
wsw <- function(from, to = paste0(from, '/rttm/'),
                        pycall = '~/miniconda3/envs/py38phdz/bin/python'){

  # process time
  pt0 <- proc.time()

  # removing duplicates, using the first directory provided
  from <- from[1]

  # getting python functions - MUST BE A BETTER WAY TO DO THIS!
  unlink(paste0(getwd(),'/temp_libs.py'))
  if(!file.exists(paste0(getwd(),'/temp_libs.py'))){
    utils::download.file('https://raw.githubusercontent.com/filipezabala/voice/master/tests/libs.py',
                         'temp_libs.py')
  }

  unlink(paste0(getwd(),'/temp_diarization-pyannote.py'))
  if(!file.exists(paste0(getwd(),'/temp_diarization-pyannote.py'))){
    utils::download.file('https://raw.githubusercontent.com/filipezabala/voice/master/tests/diarization-pyannote.py',
                         'temp_diarization-pyannote.py')
  }

  cmd <- paste(pycall, '-m temp_diarization-pyannote --pathfrom', from, '--pathto', to)
  system(cmd, wait = FALSE, intern = T)
}
