#'  Time duration
#'
#' @description Get time duration from WAV file.
#' @param x Wave object from `tuneR::readWave`.
#' @return Numeric indicating the time duration in seconds from a WAV file.
#' @examples
#' library(voice)
#'
#' # get path to audio file
#' path2wav <- list.files(system.file('extdata', package = 'wrassp'),
#' pattern <- glob2rx('*.wav'), full.names = TRUE)
#'
#' rw <- tuneR::readWave(path2wav[1])
#' voice::get_dur(rw)
#'
#' rwl <- lapply(path2wav, tuneR::readWave)
#' sapply(rwl, voice::get_dur)
#' @export
get_dur <- function(x){
  return(length(x@left)/x@samp.rate)
}
