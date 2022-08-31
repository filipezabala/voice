#'  Get right channel
#'
#' @description Get right channel from WAV file.
#' @param x Wave object from `tuneR::readWave`.
#' @return A numeric vector indicating the right channel from a WAV file.
#' @examples
#' library(voice)
#'
#' # get path to audio file
#' path2wav <- list.files(system.file('extdata', package = 'wrassp'),
#' pattern <- glob2rx('*.wav'), full.names = TRUE)
#'
#' rw <- tuneR::readWave(path2wav[1])
#' r <- voice::get_right(rw)
#' head(r)
#' length(r)
#' @export
get_right <- function(x){
  return(x@right)
}
