#' Returns the total time of audio files in seconds
#'
#' @param x Either a WAV file or a directory containing WAV files.
#' @param get.id Logical. Should the ID must be extracted from file name? Default: \code{FALSE}.
#' @param recursive Logical.
#' @param i ID position in file name. Default: \code{4}.
#' @export
audio_time <- function(x, get.id = FALSE, recursive = FALSE, i = 4){
  # checking if x is a file or directory
  if(file_test('-f', x)){
    wavDir <- dirname(x)
    wavFiles <- x
  } else{
    wavDir <- x
    wavFiles <- dir(wavDir, pattern = '.[Ww][Aa][Vv]$', full.names = TRUE,
                    recursive = recursive)
  }
  # calculating
  if(length(wavFiles) > 0){
    a <- lapply(wavFiles, tuneR::readWave)
    gl <- lapply(a, voice::get_left)
    sr <- lapply(a, voice::get_samp.rate)
    le <- lapply(gl, length)
    at <- unlist(Map('/', le, sr))
    if(get.id){
      ss <- unlist(strsplit(wavFiles, '.[Ww][Aa][Vv]$'))
      # ss <- sapply(ss, strsplit, '[_]')
      # geti <- function(x){
      #   as.integer(x[i])
      # }
      # id.label <- sapply(ss, geti)
      at <- bind_cols(filename = basename(ss), tag_audio_time = at)
      return(at)
    } else{
      return(at)
    }
  } else{
    cat('NO WAV FILES IN DIRECTORY!')
  }
}
