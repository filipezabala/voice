#'  Get bit rate
#'
#' @description Get bit rate from WAV file.
#' @param x Wave object from `tuneR::readWave`.
#' @return An integer scalar indicating the bit rate from a WAV file.
#' @examples
#' library(voice)
#'
#' # get path to audio file
#' path2wav <- list.files(system.file('extdata', package = 'wrassp'),
#' pattern <- glob2rx('*.wav'), full.names = TRUE)
#'
#' rw <- tuneR::readWave(path2wav[1])
#' voice::get_bit(rw)
#'
#' rwl <- lapply(path2wav, tuneR::readWave)
#' sapply(rwl, voice::get_bit)
#' @export
get_bit <- function(x){
  return(x@bit)
}
