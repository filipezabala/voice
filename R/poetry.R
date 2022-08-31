#' Poetry. The best words in their best order.
#'
#' Diarization from WAV audios using 'Python's' 'pyannote-audio' library.
#'
#' @param fromWav A directory/folder containing WAV files.
#' @param toRttm A directory/folder to write RTTM files. If the default \code{toRttm = NULL} is used, \code{'./voiceAudios/rttm'} is created and used.
#' @param autoDir Logical. Must the directories tree must be created? Default: \code{FALSE}. See 'Details'.
#' @param pycall Python call.
#' @return RTTM files in NIST standard. See 'voice::read_rttm'.
#' @details When \code{autoDir = TRUE}, the following directories are created: \code{'../mp3'},\code{'../rttm'}, \code{'../split'} and \code{'../musicxml'}. Use \code{getwd()} to find the parent directory \code{'../'}.
#' @examples
#' \dontrun{
#' library(voice)
#'
#' wavDir <- list.files(system.file('extdata', package = 'wrassp'),
#' pattern <- glob2rx('*.wav'), full.names = TRUE)
#'
#' voice::poetry(fromWav = unique(dirname(wavDir)), toRttm = tempdir())
#' dir(tempdir())
#' }
#' @export
poetry <- function(fromWav, toRttm = NULL, autoDir = FALSE,
                   pycall = '~/miniconda3/envs/pyvoice38/bin/python3.8'){

  if(autoDir){
    wavDir <- fromWav[1]
    ss <- unlist(strsplit(wavDir, '/'))
    parDir <- paste0(ss[-length(ss)], collapse ='/')
    mp3Dir <- paste0(parDir, '/mp3')
    rttmDir <- paste0(parDir, '/rttm')
    splitDir <- paste0(parDir, '/split')
    mxmlDir <- paste0(parDir, '/musicxml')
    ifelse(!dir.exists(parDir), dir.create(parDir), 'Directory exists!')
    ifelse(!dir.exists(wavDir), dir.create(wavDir), 'Directory exists!')
    ifelse(!dir.exists(mp3Dir), dir.create(mp3Dir), 'Directory exists!')
    ifelse(!dir.exists(rttmDir), dir.create(rttmDir), 'Directory exists!')
    ifelse(!dir.exists(splitDir), dir.create(splitDir), 'Directory exists!')
    ifelse(!dir.exists(mxmlDir), dir.create(mxmlDir), 'Directory exists!')
  }

  if(is.null(toRttm)){
    toRttm <- rttmDir
  }

  # Melhoria: ordenar (por alguma regra) arquivos para extração

  # process time
  pt0 <- proc.time()
  st0 <- Sys.time()

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

  cmd <- paste(pycall, '-m temp_diarization-pyannote --pathfrom', fromWav, '--pathto', toRttm)
  system(cmd, wait = FALSE, intern = T)
  print(Sys.time()-st0)
}
