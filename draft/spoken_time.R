#' Returns the spoken time of audio files
#'
#' @param x Either a WAV file or a directory containing WAV files.
#' @param get.id Logical. Should the ID must be extracted from file name? Default: \code{FALSE}.
#' @param recursive Logical. Should the listing recursively into directories? (default: \code{FALSE}) Used by \code{base::list.files}.
#' @param pycall Python call.
#' @export
spoken_time <- function(x, get.id = FALSE, recursive = FALSE,
                        pycall = '/home/linuxbrew/.linuxbrew/bin/python3.9'){
  # checking if x is a file or directory
  if(utils::file_test('-f', x)){
    wavDir <- dirname(x)
    wavFiles <- x
  } else{
    wavDir <- x
    wavFiles <- dir(wavDir, pattern = '.[Ww][Aa][Vv]$', full.names = TRUE,
                    recursive = recursive)
  }
  # calculating
  if(length(wavFiles) > 0){
    voice::poetry(wavDir, autoDir = TRUE, pycall = pycall)
    voice::splitw(wavDir, autoDir = TRUE, subDir = TRUE)
    ss <- unlist(strsplit(wavDir, '/'))
    parDir <- paste0(ss[-length(ss)], collapse ='/')
    splitDir <- paste0(parDir, '/split')
    st <- audio_time(splitDir, recursive = TRUE)
    spl <- strsplit(st$filename, '_split_')
    geti <- function(x, i){ x[i] }
    st$filename <- sapply(spl, geti, 1)
    st <- st %>%
      dplyr::group_by(filename) %>%
      plyr::summarise(tag_spoken_time = sum(tag_audio_time))
    if(get.id){
      return(st)
    } else{
      return(st$tag_audio_time)
    }
  } else{
    cat('NO WAV FILES IN DIRECTORY!')
    }
}
