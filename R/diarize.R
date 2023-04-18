#' Who spoke when?
#'
#' Diarization of WAV audios.
#'
#' @param fromWav Either a file or a directory containing WAV files.
#' @param toRttm A directory to write RTTM files. If the default \code{toRttm = NULL} is used, \code{'./voiceAudios/rttm'} is created and used.
#' @param autoDir Logical. Must the directories tree be created? Default: \code{FALSE}. See 'Details'.
#' @param pycall Python call. See \url{https://github.com/filipezabala/voice} for details.
#' @param token Access token needed to instantiate pretrained speaker diarization pipeline from pyannote.audio. #1. Visit \url{https://hf.co/pyannote/speaker-diarization} and accept user conditions. #2. Visit \url{https://hf.co/pyannote/segmentation} and accept user conditions. #3. Visit \url{https://hf.co/settings/tokens} to create an access token. More details at \url{https://github.com/pyannote/pyannote-audio}.
#' @return RTTM files in NIST standard. See 'voice::read_rttm'.
#' @details When \code{autoDir = TRUE}, the following directories are created: \code{'../mp3'},\code{'../rttm'}, \code{'../split'} and \code{'../musicxml'}. Use \code{getwd()} to find the parent directory \code{'../'}.
#' @import reticulate
#' @examples
#' \dontrun{
#' library(voice)
#'
#' wavDir <- list.files(system.file('extdata', package = 'wrassp'),
#' pattern = glob2rx('*.wav'), full.names = TRUE)
#'
#' voice::diarize(fromWav = unique(dirname(wavDir)),
#' toRttm = tempdir(),
#' token = NULL) # Must enter a token! See documentation.
#'
#' (rttm <- dir(tempdir(), '.[Rr][Tt][Tt][Mm]$', full.names = TRUE))
#' file.info(rttm)
#' }
#' @export
diarize <- function(fromWav, toRttm = NULL, autoDir = FALSE,
                    pycall = '~/miniconda3/envs/pyvoice38/bin/python3.8',
                    token = NULL){

  if(is.null(token)){
    stop('Must enter a token!')
  }

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

  #TODO: sort (by some rule) files for extraction

  # process time
  pt0 <- proc.time()
  st0 <- Sys.time()

  reticulate::use_condaenv(pycall, required = TRUE)
  pyannote <- reticulate::import('pyannote.audio')
  pipeline <- pyannote$Pipeline$from_pretrained('pyannote/speaker-diarization',
                                                use_auth_token = token)

  #TODO: solve 'with closing file handler' issue.

  wavFiles <- dir(fromWav, '.[Ww][Aa][Vv]$', full.names = TRUE)

  for(i in wavFiles){
    diarization <- pipeline(i)
    py <- reticulate::import_builtins()
    rttmFile <- sub('.[Ww][Aa][Vv]$', '.rttm', i)
    rttmBase <- basename(rttmFile)
    rttmTo <- paste0(toRttm, '/', rttmBase)
    # rttmTo <- normalizePath(paste0(toRttm, rttmBase))
    f <- py$open(rttmTo, 'w')
    diarization$write_rttm(f)
    f$close()
  }

  print(Sys.time()-st0)
}
