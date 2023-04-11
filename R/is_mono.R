#' Verify if an audio is mono
#'
#' @usage is_mono(x)
#' @param x Path to WAV audio file.
#' @return Logical. `TRUE` indicates a mono (one-channel) file. `FALSE` indicates a non-mono (two-channel) file.
#' @examples
#' library(voice)
#'
#' # get path to audio file
#' path2wav <- list.files(system.file('extdata', package = 'wrassp'),
#' pattern = glob2rx('*.wav'), full.names = TRUE)
#'
#' is_mono(path2wav[1])
#' sapply(path2wav, is_mono)
#' @export
is_mono <- function(x){
  audio <- tuneR::readWave(x, 1, 2)
  is.mono <- tuneR::nchannel(audio) == 1
  return(is.mono)
}
