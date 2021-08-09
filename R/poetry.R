#' Poetry. The best words in their best order.
#'
#' Diarization from WAV audios using Python's pyannote-audio library.
#'
#' @param fromWav A directory/folder containing WAV files.
#' @param to A directory/folder to write RTTM files.
#' @param pycall Python call.
#' @examples
#' library(voice)
#' path2wav <- list.files(system.file('extdata', package = 'wrassp'),
#'                                    pattern <- glob2rx('*.wav'), full.names = TRUE)
#' dir.create(rttm <- paste0(dirname(path2wav)[1], '/rttm/'))
#' wsw(from = dirname(path2wav)[1], to = rttm)
#' @export
poetry <- function(fromWav, to, pycall = '~/miniconda3/envs/pyvoice38/bin/python3.8'){

  # Melhoria: ordenar arquivos para extração

  # process time
  pt0 <- proc.time()
  st0 <- Sys.time()

  # removing duplicates, using the first directory provided
  fromWav <- fromWav[1]

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

  cmd <- paste(pycall, '-m temp_diarization-pyannote --pathfrom', fromWav, '--pathto', to)
  system(cmd, wait = FALSE, intern = T)
  print(Sys.time()-st0)
}
