#'  Get sample rate
#'
#' @description Get sample rate from WAV file.
#' @param x Wave object from `tuneR::readWave`.
#' @return Integer indicating the sample rate from a WAV file.
#' @examples
#' library(voice)
#'
#' # get path to audio file
#' path2wav <- list.files(system.file('extdata', package = 'wrassp'),
#' pattern <- glob2rx('*.wav'), full.names = TRUE)
#'
#' rw <- tuneR::readWave(path2wav[1])
#' voice::get_samp.rate(rw)
#'
#' rwl <- lapply(path2wav, tuneR::readWave)
#' sapply(rwl, voice::get_samp.rate)
#' @export
get_samp.rate <- function(x){
  return(x@samp.rate)
}
