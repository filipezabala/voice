#'  Get left channel
#'
#' @description Get left channel from WAV file.
#' @param x Wave object from `tuneR::readWave`.
#' @return A numeric vector indicating the left channel from a WAV file.
#' @examples
#' library(voice)
#'
#' # get path to audio file
#' path2wav <- list.files(system.file('extdata', package = 'wrassp'),
#' pattern <- glob2rx('*.wav'), full.names = TRUE)
#'
#' rw <- tuneR::readWave(path2wav[1])
#' l <- voice::get_left(rw)
#' head(l)
#' length(l)
#' @export
get_left <- function(x){
  return(x@left)
}
