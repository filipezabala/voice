#' Returns the total time of audio files in seconds
#'
#' @param x Either a WAV file or a directory containing WAV files.
#' @param filesRange The desired range of directory files (default: \code{NULL}, i.e., all files).
#' @param recursive Logical. Should the listing recursively into directories? (default: \code{FALSE}) Used by \code{base::list.files}.
#' @return A tibble containing file name <chr> and audio time <dbl>.
#' @examples
#' library(voice)
#'
#' # get path to audio file
#' path2wav <- list.files(system.file('extdata', package = 'wrassp'),
#' pattern <- glob2rx('*.wav'), full.names = TRUE)
#'
#' # Tibble containing file name and audio time
#' (at <- voice::audio_time(unique(dirname(path2wav))))
#' str(at)
#' @export
audio_time <- function(x, filesRange = NULL, recursive = FALSE){

  # checking if x is a file or directory
  if(utils::file_test('-f', x)){
    wavDir <- dirname(x)
    wavFiles <- x
  } else{
    wavDir <- x
    wavFiles <- dir(wavDir, pattern = '.[Ww][Aa][Vv]$', full.names = TRUE,
                    recursive = recursive)
  }

  # filtering by filesRange
  if(!is.null(filesRange)){
    fullRange <- 1:length(wavFiles)
    filesRange <- base::intersect(fullRange, filesRange)
    wavFiles <- wavFiles[filesRange]
  }

  # file_name (no extension)
  fn <- unlist(strsplit(basename(wavFiles), '.[Ww][Aa][Vv]$'))

  # calculating
  if(length(wavFiles) > 0){
    a <- lapply(wavFiles, tuneR::readWave)
    gl <- lapply(a, voice::get_left)
    sr <- lapply(a, voice::get_samp.rate)
    le <- lapply(gl, length)
    at <- unlist(Map('/', le, sr))
    at <- dplyr::bind_cols(file_name = fn, tag_audio_time = at)
    return(at)
    }
  else{
    cat('NO WAV FILES IN DIRECTORY!')
  }
}
